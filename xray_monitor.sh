#!/bin/sh /etc/rc.common
START=99
STOP=10
COMMAND="/tmp/etc/passwall/bin/xray run -c /tmp/etc/passwall/acl/default/TCP_SOCKS_DNS.json"
SERVICE_RESTART="service restart passwall"
LOG_FILE="/tmp/xray_monitor.log"

start() {
    nohup sh -c "
    while true; do
        if ! pgrep -f \"$COMMAND\" > /dev/null; then
            echo \"\$(date): Process not running. Restarting service...\" >> $LOG_FILE
            $SERVICE_RESTART
        fi
        sleep 5
    done" &
}

stop() {
    killall -q -f "$COMMAND"
}
