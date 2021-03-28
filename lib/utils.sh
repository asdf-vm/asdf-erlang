export KERL_VERSION="${ASDF_KERL_VERSION:-2.1.1}"



printerr() {
  >&2 printf '\033[0;31m%s\033[0m \n' "$1"
}

ensure_kerl_setup() {

  export KERL_BASE_DIR="${ASDF_KERL_BASE_DIR:-${ASDF_DATA_DIR:-$HOME/.asdf}/tmp/$(plugin_name)/kerl}"
  export KERL_CONFIG="${KERL_BASE_DIR:-$(kerl_path)}/.kerlrc"
  
  ensure_kerl_installed
}

ensure_kerl_installed() {
  # If kerl exists
  if [ -x "$(kerl_executable)" ]; then
    # But was passed an expected version
    if [ -n "${ASDF_KERL_VERSION:-}" ]; then
      current_kerl_version="$("$(kerl_executable)" version)"
      # Check if expected version matches current version
      if [ "$current_kerl_version" != "$KERL_VERSION" ]; then
        # If not, reinstall with ASDF_KERL_VERSION
        download_kerl
      fi
    fi
  else
    # kerl does not exist, so install using default value in KERL_VERSION
    download_kerl
  fi
}



download_kerl() {
  # Remove directory in case it still exists from last download
  rm -rf "$(kerl_source_path)"
  rm -rf "$(kerl_path)"

  # Print to stderr so asdf doesn't assume this string is a list of versions
  printerr 'Installing %s ' "$KERL_INSTALL_VERSION"

  # Clone down and checkout the correct kerl version
  git clone https://github.com/kerl/kerl.git "$(kerl_source_path)" --quiet
  (cd "$(kerl_source_path)"; git checkout $KERL_INSTALL_VERSION --quiet;)

  mkdir -p "$(kerl_path)/bin"
  mv "$(kerl_source_path)/kerl" "$(kerl_executable)"
  chmod +x "$(kerl_executable)"

  rm -rf "$(kerl_source_path)"
}


asdf_erlang_plugin_path() {
  echo "$(dirname "$(dirname "$0")")"
}

plugin_name() {
  basename $(asdf_erlang_plugin_path)
}

kerl_path() {
  echo "$(asdf_erlang_plugin_path)/kerl"
}

kerl_source_path() {
  echo "$(kerl_path)-source"
}


kerl_executable() {
  #Check if kerl exists without an expected version
  if [ -x "$(command -v kerl)" ] && [ -z "${ASDF_KERL_VERSION:-}" ]; then
    echo "$(command -v kerl)"
  else
    echo "$(kerl_path)/bin/kerl"
  fi
}

get_macos_marketing_name() {
  if [ "$(uname -s)" = "Darwin" ]; then
    osx_num=$(SYSTEM_VERSION_COMPAT=1 sw_vers -productVersion | awk -F '[.]' '{print $2}')
    OSX_MARKETING=(
        ["10"]="yosemite"
        ["11"]="el_capitan"
        ["12"]="sierra"
        ["13"]="high_sierra"
        ["14"]="mojave"
        ["15"]="catalina"
        ["16"]="big_sur"
      )

    if [[ -n "${OSX_MARKETING[$osx_num]}" ]]; then 
      printf '%s\n' "${OSX_MARKETING[$osx_num]}"
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

macos_get_download_url() {
  local os_name=$(
      if [ "$(uname -m)" = "arm64" ]; then 
        printf "arm64_%s" "$1"
      else
        printf "%s" "$1"
      fi
    )

  printf 'Looking for prebuilt %s %s on %s. \n' "$(plugin_name)" "$ASDF_INSTALL_VERSION" "$os_name" >&2
  local erlang_version="erlang-$ASDF_INSTALL_VERSION"
  local file_name="$erlang_version.$os_name.bottle.tar.gz"
  local url="https://bintray.com/homebrew/bottles/download_file?file_path=$file_name"

  if curl --output /dev/null --silent --head --fail "$url"; then
    printf '%s' $url
    return 0
  else
    printerr 'No prebuilt %s %s for %s is available. ' "$(plugin_name)" "$ASDF_INSTALL_VERSION" "$os_name"
    return 1
  fi
}

macos_update_linked_paths() {

  
  local file_paths=("$@")
  
  local brew_prefix="$(brew --prefix)"
  local replacement="@@HOMEBREW_PREFIX@@"

  for file in "${file_paths[@]}"; do
    local changes=()
    for line in $(otool -L "$file"); do
      if [[ "$line" == "$replacement"* ]]; then
        local result="${line/$replacement/$brew_prefix}"
        changes+=("-change" "$line" "$result")
      fi
    done
    local command=(install_name_tool "${changes[@]}" "$file")
    "${command[@]}"

    # https://github.com/Homebrew/brew/blob/565becc90433df57c9ec6262dec1f41797fb680b/Library/Homebrew/os/mac/keg.rb#L21
    cp "$file" "$file.backup"
    codesign -s - -f -vvvvvv "$file.backup"
    mv -f "$file.backup" "$file"
  done

}

macos_check_homebrew_setup() {
  
  local brew_function="${1:-PREBUILT}"
  
  printf 'Checking Homebrew for dependencies. \n'
  if [ -x "$(command -v brew)" ]; then
    if [ "$brew_function" = "SOURCE" ] && [ ! -d "$(brew --prefix autoconf)" ]; then
      printerr 'Missing autoconf from Homebrew '
      printf 'Fix with: brew install autoconf \n'
      exit 1
    fi
    if [ "$brew_function" = "SOURCE" ] && [ ! -d "$(brew --prefix libtool)" ]; then
      printerr 'Missing libtool from Homebrew'
      printf 'Fix with: brew install libtool \n'
      exit 1
    fi
    if [ ! -d "$(brew --prefix openssl)" ]; then
      printerr 'Missing openssl from Homebrew'
      printf 'Fix with: brew install openssl \n'
      exit 1
    fi
    if [ ! -d "$(brew --prefix wxmac)" ]; then
      printerr 'Missing wxmac from Homebrew'
      printf 'Fix with: brew install wxmac \n'
      exit 1
    fi
    return 0
  else
      printerr 'Homebrew is not installed or in PATH'
      printf 'To install without Homebrew, set your own KERL_CONFIGURE_OPTIONS \n'
      exit 1
  fi
}
