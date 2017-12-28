ensure_kerl_installed() {
    if [ ! -f "$(kerl_path)" ]; then
        download_kerl
    fi
}

download_kerl() {
    echo "Downloading kerl..."
    local kerl_url="https://raw.githubusercontent.com/kerl/kerl/1.8.1/kerl"
    curl -Lo $kerl_url "$(kerl_path)"
    chmod +x "$(kerl_path)"
}

kerl_path() {
    # TODO: This may be wrong
    "kerl"
}
