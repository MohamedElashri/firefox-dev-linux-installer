# Firefox Developer Edition Installer

This repository contains a simple bash script to install and update Firefox Developer Edition on Linux systems. The script ensures that Firefox Developer Edition is always up to date and only installs it if a new version is available. It also sets up desktop integration for easier access.

## How to Use

1. Clone the repository:

   ```bash
   git clone https://github.com/MohamedElashri/firefox-dev-linux-installer
   ```

2. Navigate into the repository:

   ```bash
   cd firefox-dev-installer
   ```

3. Make the script executable:

   ```bash
   chmod +x install-firefox-developer.sh
   ```

4. Run the script:

   ```bash
   ./install-firefox-developer.sh
   ```

The script will handle the installation, updates, and desktop integration automatically. In case of updated you will need to re-run it or use it as a cron job. 

## What It Does

- Downloads and installs Firefox Developer Edition if it's not installed.
- Checks if a newer version is available and updates it if necessary.
- Sets up desktop integration for easy launching from your application menu.

---

That’s all you need to get started with Firefox Developer Edition on your Linux system.
