ensure_kerl_installed() {
    if [ ! -f "$(kerl_path)" ]; then
        download_kerl
    fi
}

download_kerl() {
    # Print to stderr so asdf doesn't assume this string is a list of versions
    echo "Downloading kerl..." >&2

    local kerl_version="1.8.1"
    local kerl_url="https://raw.githubusercontent.com/kerl/kerl/${kerl_version}/kerl"

    curl -Lso "$(kerl_path)" $kerl_url
    chmod +x "$(kerl_path)"
}

kerl_path() {
    echo "$(dirname "$(dirname $0)")/kerl"
}

update_available_versions() {
   "$(kerl_path)" update releases > /dev/null
}
