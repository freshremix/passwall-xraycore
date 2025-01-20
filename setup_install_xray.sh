#!/bin/bash

# Define the script URL and local path
SCRIPT_URL="https://raw.githubusercontent.com/freshremix/passwall-xraycore/main/install_xray.sh"
LOCAL_SCRIPT_PATH="/install_xray.sh"
RC_LOCAL="/etc/rc.local"

# Ensure the script is executed with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Download the install_xray.sh script if it doesn't exist
if [ ! -f "$LOCAL_SCRIPT_PATH" ]; then
    echo "Downloading install_xray.sh..."
    wget -O "$LOCAL_SCRIPT_PATH" "$SCRIPT_URL" || {
        echo "Failed to download $SCRIPT_URL."
        exit 1
    }
    chmod +x "$LOCAL_SCRIPT_PATH"
else
    echo "$LOCAL_SCRIPT_PATH already exists."
fi

# Ensure /etc/rc.local exists and is executable
if [ ! -f "$RC_LOCAL" ]; then
    echo "Creating $RC_LOCAL..."
    echo -e "#!/bin/bash\nexit 0" > "$RC_LOCAL"
    chmod +x "$RC_LOCAL"
fi

# Add the script to rc.local for boot persistence if not already added
if ! grep -q "$LOCAL_SCRIPT_PATH" "$RC_LOCAL"; then
    echo "Adding $LOCAL_SCRIPT_PATH to $RC_LOCAL..."
    sed -i "/exit 0/i $LOCAL_SCRIPT_PATH &" "$RC_LOCAL"
else
    echo "$LOCAL_SCRIPT_PATH is already in $RC_LOCAL."
fi

# Run the install_xray.sh script immediately
if [ -x "$LOCAL_SCRIPT_PATH" ]; then
    echo "Running $LOCAL_SCRIPT_PATH..."
    "$LOCAL_SCRIPT_PATH"
else
    echo "Failed to find or execute $LOCAL_SCRIPT_PATH."
    exit 1
fi
