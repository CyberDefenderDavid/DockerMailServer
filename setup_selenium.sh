#!/bin/bash

# Function to check if the OS is Debian
is_debian() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = "debian" ]; then
      return 0
    fi
  fi
  return 1
}

# Set the appropriate package installation command
INSTALL_CMD="sudo apt install -y"
if is_debian; then
  INSTALL_CMD="apt install -y"
fi

# Step 1: Ensure required packages are installed
apt update
$INSTALL_CMD python3.11-venv curl unzip wget libglib2.0-0

# Step 2: Install Google Chrome if not already installed
if ! command -v google-chrome &> /dev/null; then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  $INSTALL_CMD ./google-chrome-stable_current_amd64.deb
fi

# Step 3: Create a virtual environment if it doesn't exist
if [ ! -d "selenium_env" ]; then
  python3 -m venv selenium_env
fi

# Step 4: Activate the virtual environment
source selenium_env/bin/activate

# Step 5: Install Selenium if not already installed
if ! python -c "import selenium" &> /dev/null; then
  pip install selenium
fi

# Step 6: Install ChromeDriver if not already installed
CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
CHROME_DRIVER_PATH="/usr/local/bin/chromedriver"
if [ ! -f "$CHROME_DRIVER_PATH" ] || ! $CHROME_DRIVER_PATH --version | grep -q "$CHROME_DRIVER_VERSION"; then
  wget -N "https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" -P ~/
  unzip -o ~/chromedriver_linux64.zip -d ~/
  mv -f ~/chromedriver /usr/local/bin/chromedriver
  chmod +x /usr/local/bin/chromedriver
fi

# Verify installations
echo "Verification Results:"

if command -v python3 &> /dev/null; then
    echo "Python is installed."
    python3 --version
else
    echo "Python is not installed."
fi

if command -v pip &> /dev/null; then
    echo "pip is installed."
    pip --version
else
    echo "pip is not installed."
fi

if python3 -c "import selenium" &> /dev/null; then
    echo "Selenium is installed."
    python3 -c "import selenium; print('Selenium version:', selenium.__version__)"
else
    echo "Selenium is not installed."
fi

if command -v google-chrome &> /dev/null; then
    echo "Google Chrome is installed."
    google-chrome --version
else
    echo "Google Chrome is not installed."
fi

if command -v chromedriver &> /dev/null; then
    echo "ChromeDriver is installed."
    chromedriver --version
else
    echo "ChromeDriver is not installed."
fi
