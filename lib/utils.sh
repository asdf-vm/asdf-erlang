export KERL_VERSION="${ASDF_KERL_VERSION:-2.1.1}"



echoerr() {
  >&2 echo -e "\033[0;31m$1\033[0m"
}

ensure_kerl_setup() {
  export KERL_BASE_DIR="$(kerl_path)"
  export KERL_CONFIG="$(kerl_path)/kerlrc"
  #export KERL_BUILD_BACKEND="git"
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
  echoerr "Downloading kerl $KERL_INSTALL_VERSION"

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
