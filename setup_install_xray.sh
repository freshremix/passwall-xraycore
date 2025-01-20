#!/bin/sh

# Define the script URL and local path
SCRIPT_URL="https://raw.githubusercontent.com/freshremix/passwall-xraycore/main/install_xray.sh"
LOCAL_SCRIPT_PATH="/etc/install_xray.sh"

# Download the install_xray.sh script if it doesn't exist
if [ ! -f "$LOCAL_SCRIPT_PATH" ]; then
    echo "Downloading install_xray.sh..."
    wget -O "$LOCAL_SCRIPT_PATH" "$SCRIPT_URL"
    chmod +x "$LOCAL_SCRIPT_PATH"
fi

# Add to rc.local for boot persistence if not already added
RC_LOCAL="/etc/rc.local"
if ! grep -q "$LOCAL_SCRIPT_PATH" "$RC_LOCAL"; then
    echo "Adding $LOCAL_SCRIPT_PATH to $RC_LOCAL..."
    sed -i "/exit 0/i $LOCAL_SCRIPT_PATH &" "$RC_LOCAL"
fi

# Run the install_xray.sh script immediately
echo "Running $LOCAL_SCRIPT_PATH..."
"$LOCAL_SCRIPT_PATH"
