#!/bin/bash

# Update and upgrade the system
apt-get update -y && apt-get upgrade -y

# Install required packages
apt-get install -y wget unzip python3 python3-venv python3-pip libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libnss3 libnspr4 libxrandr2 libasound2 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libgbm1 libgtk-3-0 libxshmfence1

# Check if Google Chrome is installed
if ! command -v google-chrome &> /dev/null; then
    # Download and install Google Chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    dpkg -i google-chrome-stable_current_amd64.deb
    apt-get install -f -y
    # Delete the .deb file after installation
    rm -f google-chrome-stable_current_amd64.deb
else
    echo "Google Chrome is already installed."
fi

# Create and activate a Python virtual environment
python3 -m venv selenium_env
source selenium_env/bin/activate

# Install Selenium and webdriver-manager
pip install selenium webdriver-manager beautifulsoup4

# Deactivate the virtual environment
deactivate
