#!/bin/sh
cat <<'EOF' > /etc/init.d/xray_protect
START=99
stop() {
killall xray
}
start() {
while true; do
pid=$(pidof xray)
if [ -n "$pid" ]; then
echo -1000 > /proc/$pid/oom_score_adj
else
logger "xray process not running"
fi
sleep 5
done
}
EOF
chmod +x /etc/init.d/xray_protect
/etc/init.d/xray_protect enable
/etc/init.d/xray_protect start
/etc/init.d/xray_protect status
cat /proc/$(pidof xray)/oom_score_adj
