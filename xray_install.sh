#!/bin/sh
# Check if the script has already run
if [ -f /etc/xray_installed.flag ]; then
    echo "Xray installation already completed."
    exit 0
fi

# دانلود بسته xray-core
wget -O /tmp/xray-core.ipk "https://kumisystems.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-21.02/mipsel_24kc/passwall_packages/xray-core_25.1.1-1_mipsel_24kc.ipk?viasf=1"

# بروزرسانی opkg و نصب بسته
opkg update
opkg --dest ram install /tmp/xray-core.ipk

# پیدا کردن باینری xray و انتقال آن به محل دلخواه
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

# تایید نصب xray
/tmp/usr/bin/xray version

# علامت‌گذاری اجرای اسکریپت
touch /etc/xray_installed.flag

# کپی و فعال‌سازی اسکریپت init
cp /install_xray.sh /etc/init.d/install_xray
chmod +x /etc/init.d/install_xray
/etc/init.d/install_xray enable

# بروزرسانی قوانین passwall
cd /usr/share/passwall/rules/
rm -r direct_ip
wget https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_ip

rm -r direct_host
wget https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_host

# راه‌اندازی مجدد سرویس passwall
/etc/init.d/passwall restart
