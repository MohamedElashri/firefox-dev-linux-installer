#!/bin/bash

# START
set -e

FIREFOX_DIR="/opt/firefox-developer"
FIREFOX_BIN="/usr/bin/firefox-developer"
DESKTOP_FILE="/usr/share/applications/firefox-developer.desktop"
LATEST_URL="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64"
TARBALL="firefox-developer.tar.bz2"

# Function to get the installed version
get_installed_version() {
    if [ -x "$FIREFOX_BIN" ]; then
        "$FIREFOX_BIN" --version | awk '{print $3}'
    else
        echo "none"
    fi
}

# Function to get the version from the freshly downloaded tarball
get_downloaded_version() {
    tar -xf "$TARBALL"
    ./firefox/firefox --version | awk '{print $3}'
    rm -rf firefox
}

# Check if Firefox Developer is already installed and up-to-date
installed_version=$(get_installed_version)

# Download the latest version
curl -L -o "$TARBALL" "$LATEST_URL"
downloaded_version=$(get_downloaded_version)

echo "Installed version: $installed_version"
echo "Downloaded version: $downloaded_version"

# Uninstall if installed version is different from the latest downloaded version
if [ "$installed_version" != "$downloaded_version" ]; then
    echo "Updating to the latest version..."

    # Remove old binaries
    sudo rm -rf "$FIREFOX_DIR" "$FIREFOX_BIN"

    # Extract the new version
    tar -xf "$TARBALL"
    rm -rf "$TARBALL"
    mv firefox firefox-developer

    # Install
    sudo mv firefox-developer /opt
    sudo ln -s /opt/firefox-developer/firefox /usr/bin/firefox-developer

    echo "Update complete to version $downloaded_version"
else
    echo "Firefox Developer is already up to date."
fi

# DESKTOP INTEGRATION
if [ ! -f "$DESKTOP_FILE" ]; then
    echo "Creating desktop integration..."

    echo -e "[Desktop Entry]\nEncoding=UTF-8\nName=Firefox Developer Edition\nComment=Firefox Developer Edition\nExec=/opt/firefox-developer/firefox %u\nTerminal=false\nIcon=/opt/firefox-developer/browser/chrome/icons/default/default128.png\nStartupWMClass=Firefox Developer\nType=Application\nCategories=Network;WebBrowser;\nMimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;x-scheme-handler/http;x-scheme-handler/https;\nStartupNotify=true\n" | sudo tee -a "$DESKTOP_FILE"
else
    echo "Desktop integration already exists."
fi

# NOTIFY
echo "Firefox Developer Edition is ready!"
