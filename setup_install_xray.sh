#!/bin/bash

# Variables
SCRIPT_URL="https://raw.githubusercontent.com/freshremix/passwall-xraycore/main/install_xray.sh"
LOCAL_SCRIPT_PATH="/install_xray.sh"
RC_LOCAL="/etc/rc.local"
ONE_TIME_FLAG="/var/run/xray_installed"
LOG_FILE="/var/log/xray_install.log"

# Ensure root
if [ "$EUID" -ne 0 ]; then
    echo "Run as root." | tee -a "$LOG_FILE"
    exit 1
fi

# Download script
if [ ! -f "$LOCAL_SCRIPT_PATH" ]; then
    echo "Downloading script..." | tee -a "$LOG_FILE"
    wget -O "$LOCAL_SCRIPT_PATH" "$SCRIPT_URL" || {
        echo "Download failed." | tee -a "$LOG_FILE"
        exit 1
    }
    chmod +x "$LOCAL_SCRIPT_PATH"
fi

# Ensure rc.local
if [ ! -f "$RC_LOCAL" ]; then
    echo "Creating rc.local..." | tee -a "$LOG_FILE"
    echo -e "#!/bin/bash\nexit 0" > "$RC_LOCAL"
    chmod +x "$RC_LOCAL"
fi

# Update rc.local
if ! grep -q "$LOCAL_SCRIPT_PATH" "$RC_LOCAL"; then
    echo "Adding to rc.local..." | tee -a "$LOG_FILE"
    sed -i "/exit 0/i if [ ! -f \"$ONE_TIME_FLAG\" ]; then\n  $LOCAL_SCRIPT_PATH\n  touch \"$ONE_TIME_FLAG\"\nfi\n" "$RC_LOCAL"
fi

# Run script
if [ ! -f "$ONE_TIME_FLAG" ]; then
    echo "Running script for the first time..." | tee -a "$LOG_FILE"
    if "$LOCAL_SCRIPT_PATH"; then
        touch "$ONE_TIME_FLAG"
        echo "Script completed successfully." | tee -a "$LOG_FILE"
    else
        echo "Script failed." | tee -a "$LOG_FILE"
        exit 1
    fi
else
    echo "Script already executed." | tee -a "$LOG_FILE"
fi
