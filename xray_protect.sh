#!/bin/sh
vi /setup_xray_protect.sh
cat <<EOF > /etc/init.d/xray_protect
#!/bin/sh /etc/rc.common
START=99
start() {
    while true; do
        pid=$(pidof xray)
        [ -n "$pid" ] && echo -1000 > /proc/$pid/oom_score_adj
        sleep 5
    done
}
EOF
chmod +x /etc/init.d/xray_protect
/etc/init.d/xray_protect enable
/etc/init.d/xray_protect start
chmod +x /root/setup_xray_protect.sh
./setup_xray_protect.sh
/etc/init.d/xray_protect status
cat /proc/$(pidof xray)/oom_score_adj
