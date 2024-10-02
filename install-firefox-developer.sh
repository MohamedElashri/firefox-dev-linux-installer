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

# Function to get the latest available version
get_latest_version() {
    curl -sI "$LATEST_URL" | grep -i Location | awk -F'-' '{print $5}' | sed 's/\.tar\.bz2//'
}

# Check if Firefox Developer is already installed and up-to-date
installed_version=$(get_installed_version)
latest_version=$(get_latest_version)

echo "Installed version: $installed_version"
echo "Latest version: $latest_version"

# Uninstall if installed version is different from the latest
if [ "$installed_version" != "$latest_version" ]; then
    echo "Updating to the latest version..."

    # Remove old binaries
    sudo rm -rf "$FIREFOX_DIR" "$FIREFOX_BIN"

    # DOWNLOAD
    curl -L -o "$TARBALL" "$LATEST_URL"

    # EXTRACT
    tar -xf "$TARBALL"
    rm -rf "$TARBALL"
    mv firefox firefox-developer

    # INSTALL
    sudo mv firefox-developer /opt
    sudo ln -s /opt/firefox-developer/firefox /usr/bin/firefox-developer

    echo "Update complete to version $latest_version"
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
