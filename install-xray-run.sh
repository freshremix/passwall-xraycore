#!/bin/sh

# نصب پکیج xray-core
wget -O /tmp/xray-core.ipk "https://kumisystems.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-21.02/mipsel_24kc/passwall_packages/xray-core_25.1.1-1_mipsel_24kc.ipk?viasf=1"

# بروزرسانی opkg و نصب پکیج
opkg update
opkg --dest ram install /tmp/xray-core.ipk

# پیدا کردن باینری xray و انتقال آن به محل مورد نظر
XRAY_PATH=$(find / -name "xray" 2>/dev/null | head -n 1)
if [ -n "$XRAY_PATH" ]; then
    mkdir -p /tmp/usr/bin
    mv "$XRAY_PATH" /tmp/usr/bin/xray
    chmod +x /tmp/usr/bin/xray
    echo "باینری xray به /tmp/usr/bin/xray منتقل شد."
else
    echo "باینری xray پیدا نشد."
    exit 1
fi

# بررسی نصب xray
/tmp/usr/bin/xray version

# کپی اسکریپت نصب به مسیر init.d و فعال کردن آن برای راه‌اندازی خودکار
cp /install_xray.sh /etc/init.d/install_xray
chmod +x /etc/init.d/install_xray
/etc/init.d/install_xray enable

# دانلود قوانین برای بای‌پس IP ایران
cd /usr/share/passwall/rules/
rm -r direct_ip
wget https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_ip
rm -r direct_host
wget https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_host

# ریستارت سرویس passwall
/etc/init.d/passwall restart

# اضافه کردن اجرای اسکریپت timer.sh به rc.local برای اجرا در هر بار بوت
if ! grep -q "/root/timer.sh" /etc/rc.local; then
    sed -i '$i sh /root/timer.sh\n' /etc/rc.local
fi

# فایل rc.local را با اجازه اجرایی دوباره اجرا کنید
chmod +x /etc/rc.local

# اسکریپت آماده است، می‌توانید آن را اجرا کنید
echo "اسکریپت آماده شد، هر بار که مودم روشن و خاموش شود، اسکریپت دوباره اجرا می‌شود."
exit
