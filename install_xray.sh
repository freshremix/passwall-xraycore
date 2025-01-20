#!/bin/sh
# Download the xray-core package
wget -O /tmp/xray-core.ipk "https://kumisystems.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-21.02/mipsel_24kc/passwall_packages/xray-core_25.1.1-1_mipsel_24kc.ipk?viasf=1"

# Update opkg and install the package
opkg update
opkg --dest ram install /tmp/xray-core.ipk

# Find the xray binary and move it to the desired location
XRAY_PATH=$(find / -name "xray" 2>/dev/null | head -n 1)
if [ -n "$XRAY_PATH" ]; then
    mkdir -p /tmp/usr/bin
    mv "$XRAY_PATH" /tmp/usr/bin/xray
    chmod +x /tmp/usr/bin/xray
    echo "Xray binary moved to /tmp/usr/bin/xray."
else
    echo "Xray binary not found."
    exit 1
fi

# Verify the xray installation
/tmp/usr/bin/xray version



cp /install_xray.sh /etc/init.d/install_xray
chmod +x /etc/init.d/install_xray

/etc/init.d/install_xray enable

cd /usr/share/passwall/rules/

rm -r direct_ip

wget https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_ip

rm -r direct_host

wget https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_host

/etc/init.d/passwall restart
