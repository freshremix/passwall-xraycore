#!/bin/sh

SING_BOX_URL="https://raw.githubusercontent.com/freshremix/passwall-xraycore/refs/heads/main/sing-box_1.10.7-1_mips_24kc.ipk"
DIRECT_IP_URL="https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_ip"
DIRECT_HOST_URL="https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_host"
TMP_PATH="/tmp/sing-box_1.10.7-1_mips_24kc.ipk"
SING_BOX_BIN_PATH="/tmp/usr/bin/sing-box"

wget -O $TMP_PATH $SING_BOX_URL || exit 1
sleep 20
opkg update || exit 1
sleep 20
opkg --dest ram install $TMP_PATH || exit 1
sleep 20
SING_BOX_PATH=$(find / -name "sing-box" 2>/dev/null | head -n 1)
[ -n "$SING_BOX_PATH" ] && mkdir -p /tmp/usr/bin && mv "$SING_BOX_PATH" $SING_BOX_BIN_PATH && chmod +x $SING_BOX_BIN_PATH || exit 1
$SING_BOX_BIN_PATH version || exit 1
cat <<EOF > /etc/init.d/install_sing_box
#!/bin/sh /etc/rc.common
START=99
start() {
    /tmp/usr/bin/sing-box run
}
EOF
chmod +x /etc/init.d/install_sing_box
/etc/init.d/install_sing_box enable
cp /tmp/usr/bin/sing-box /etc/install_sing_box.sh
cd /usr/share/passwall/rules/ || exit 1
wget -O direct_ip $DIRECT_IP_URL || exit 1
wget -O direct_host $DIRECT_HOST_URL || exit 1
/etc/init.d/passwall restart || exit 1
rm -f $TMP_PATH /tmp/sing-box-core.ipk
echo 1 > /proc/sys/vm/oom_kill_allocating_task
