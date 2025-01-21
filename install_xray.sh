#!/bin/sh
sleep 15
wget -O /tmp/xray-core.ipk "https://kumisystems.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-21.02/mipsel_24kc/passwall_packages/xray-core_25.1.1-1_mipsel_24kc.ipk?viasf=1" || exit 1
sleep 5
opkg update
sleep 10
opkg --dest ram install /tmp/xray-core.ipk || exit 1
XRAY_PATH=$(find / -name "xray" 2>/dev/null | head -n 1)
[ -n "$XRAY_PATH" ] && mkdir -p /tmp/usr/bin && mv "$XRAY_PATH" /tmp/usr/bin/xray && chmod +x /tmp/usr/bin/xray || exit 1
/tmp/usr/bin/xray version || exit 1
cat <<EOF > /etc/init.d/install_xray
#!/bin/sh /etc/rc.common
START=99
start() {
    sh /etc/install_xray.sh
}
EOF
chmod +x /etc/init.d/install_xray
/etc/init.d/install_xray enable
cp $0 /etc/install_xray.sh
cd /usr/share/passwall/rules/ || exit 1
rm -f direct_ip
wget -O direct_ip https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_ip || exit 1
rm -f direct_host
wget -O direct_host https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_host || exit 1
/etc/init.d/passwall restart || exit 1
rm -f /tmp/xray-core.ipk
echo 1 > /proc/sys/vm/oom_kill_allocating_task
