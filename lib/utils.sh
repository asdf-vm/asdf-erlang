#!/usr/bin/env bash

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

get_parent_dir() {
    local asdf_script
    local asdf_bin_dir
    asdf_script=$(realpath "$0")
    asdf_bin_dir=$(dirname "$asdf_script")

    # A height of 0 represents the asdf script's directory
    local height="${1}"

    for ((i = 0; i < height; i++)); do
        asdf_bin_dir=$(dirname "$asdf_bin_dir")
    done

    printf "%s\\n" "$asdf_bin_dir"
}

ensure_kerl_installed() {
    if [ -z "$KERL_PATH" ]; then
        export KERL_PATH
        KERL_PATH="$(get_parent_dir 1)/kerl"
    fi

    local installed_kerl_version
    installed_kerl_version=$($KERL_PATH version)

    if [ ! -f "$KERL_PATH" ]; then
        # Print to stderr so asdf doesn't assume this string is a list of versions
        printf "%s\\n" "Kerl not found at expected path ($KERL_PATH), downloading version $KERL_VERSION...\n" >&2
        download_kerl
    elif [ "$($KERL_PATH version)" != "$KERL_VERSION" ]; then
        printf "%s\\n" "Found Kerl at expected path ($KERL_PATH), but installed version ($installed_kerl_version) differs from requested version ($KERL_VERSION), redownloading...\n" >&2
        # If the kerl file already exists and the version does not match, remove it and download the correct version
        rm "$KERL_PATH"
        download_kerl
    else
        printf "%s\\n" "Using installed kerl version ($installed_kerl_version) at path: $KERL_PATH\n" >&2
    fi
}

download_kerl() {
    local kerl_url="https://raw.githubusercontent.com/kerl/kerl/$KERL_VERSION/kerl"

    curl -Lo "$KERL_PATH" "$kerl_url"
    chmod +x "$KERL_PATH"
}

set_kerl_env() {
    export KERL_VERSION="${ASDF_KERL_VERSION:-2.6.0}"
    export KERL_PATH="${ASDF_KERL_PATH:-}"
    export KERL_DOWNLOAD_DIR="${ASDF_DOWNLOAD_PATH:-}"
    export KERL_BUILD_BACKEND="git"

    local kerl_home
    kerl_home="$(get_parent_dir 1)/kerl-home"
    mkdir -p "$kerl_home"
    export KERL_BASE_DIR="$kerl_home"
    export KERL_CONFIG="$kerl_home/.kerlrc"
}

update_available_versions() {
    "$(kerl_path)" update releases >/dev/null
}
