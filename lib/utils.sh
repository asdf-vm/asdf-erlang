export KERL_VERSION="${ASDF_KERL_VERSION:-4.1.0}"

handle_failure() {
    function=$1
    error_message=$2
    $function && exit_code=$? || exit_code=$?

    if [ "$exit_code" -ne 0 ]; then
        printf "%s\\n" "$error_message" 1>&2
    fi

    return "$exit_code"
}

ensure_kerl_setup() {
    handle_failure set_kerl_env 'Failed to set kerl environment'
    handle_failure ensure_kerl_installed 'Failed to install kerl'
    handle_failure update_available_versions 'Failed to update available versions'
}

ensure_kerl_installed() {
    if [ ! -f "$(kerl_path)" ]; then
        download_kerl
    elif [ "$("$(kerl_path)" version)" != "$KERL_VERSION" ]; then
        # If the kerl file already exists and the version does not match, remove
        # it and download the correct version
        rm "$(kerl_path)"
        download_kerl
    fi
}

download_kerl() {
    # Print to stderr so asdf doesn't assume this string is a list of versions
    printf "Downloading kerl...\\n" >&2

    local kerl_url="https://raw.githubusercontent.com/kerl/kerl/${KERL_VERSION}/kerl"

    curl -Lo "$(kerl_path)" "$kerl_url"
    chmod +x "$(kerl_path)"
}

kerl_path() {
    printf "%s\\n" "$(dirname "$(dirname "$0")")/kerl"
}

set_kerl_env() {
    local kerl_home
    kerl_home="$(dirname "$(dirname "$0")")/kerl-home"
    mkdir -p "$kerl_home"
    export KERL_BASE_DIR="$kerl_home"
    export KERL_BUILD_BACKEND="git"
    export KERL_CONFIG="$kerl_home/.kerlrc"
    export KERL_DOWNLOAD_DIR="${ASDF_DOWNLOAD_PATH:-}"
}

update_available_versions() {
    "$(kerl_path)" update releases >/dev/null
}
