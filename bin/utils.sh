ensure_kerl_installed() {
    if [ ! -f "$(kerl_path)" ]; then
        download_kerl
    fi
}

download_kerl() {
    echo "Downloading kerl..."
    local kerl_version="1.8.1"
    local kerl_url="https://raw.githubusercontent.com/kerl/kerl/${kerl_version}/kerl"
    curl -Lo $kerl_url "$(kerl_path)"
    chmod +x "$(kerl_path)"
}

kerl_path() {
    # TODO: This may be wrong
    "kerl"
}

update_available_versions() {
    "$(kerl_path)" update releases
}
