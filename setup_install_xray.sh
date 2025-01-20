#!/bin/bash

# Define variables
SCRIPT_URL="https://raw.githubusercontent.com/freshremix/passwall-xraycore/main/install_xray.sh"
LOCAL_SCRIPT_PATH="/install_xray.sh"
RC_LOCAL="/etc/rc.local"
ONE_TIME_FLAG="/var/run/xray_installed"

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

# Add a one-time execution command to rc.local if not present
if ! grep -q "$LOCAL_SCRIPT_PATH" "$RC_LOCAL"; then
    echo "Adding one-time execution logic to $RC_LOCAL..."
    sed -i "/exit 0/i if [ ! -f \"$ONE_TIME_FLAG\" ]; then\n  $LOCAL_SCRIPT_PATH\n  touch \"$ONE_TIME_FLAG\"\nfi\n" "$RC_LOCAL"
else
    echo "One-time execution logic already exists in $RC_LOCAL."
fi

# Run the install_xray.sh script immediately if not already executed
if [ ! -f "$ONE_TIME_FLAG" ]; then
    echo "Running $LOCAL_SCRIPT_PATH for the first time..."
    if "$LOCAL_SCRIPT_PATH"; then
        echo "Marking as completed: $ONE_TIME_FLAG"
        touch "$ONE_TIME_FLAG"
    else
        echo "Failed to execute $LOCAL_SCRIPT_PATH."
        exit 1
    fi
else
    echo "$LOCAL_SCRIPT_PATH has already been executed. Skipping."
fi
