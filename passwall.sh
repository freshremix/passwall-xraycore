opkg update
wget -O passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub
opkg-key add passwall.pub
opkg remove dnsmasq
opkg install unzip ipset ipt2socks iptables iptables-legacy iptables-mod-conntrack-extra iptables-mod-iprange iptables-mod-socket iptables-mod-tproxy kmod-ipt-nat dnsmasq-full
read release arch << EOF
$(. /etc/openwrt_release ; echo ${DISTRIB_RELEASE%.*} $DISTRIB_ARCH)
EOF
for feed in passwall_luci passwall_packages passwall2; do
  echo "src/gz $feed https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$release/$arch/$feed" >> /etc/opkg/customfeeds.conf
done
opkg update
opkg install luci-app-passwall
