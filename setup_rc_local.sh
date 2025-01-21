#!/bin/sh
touch /etc/rc.local
chmod +x /etc/rc.local
echo "exit 0" >> /etc/rc.local

touch /etc/init.d/rc.local
chmod +x /etc/init.d/rc.local
echo '#!/bin/sh /etc/rc.common' > /etc/init.d/rc.local
echo 'START=99' >> /etc/init.d/rc.local
echo 'start() {' >> /etc/init.d/rc.local
echo '    /etc/rc.local' >> /etc/init.d/rc.local
echo '}' >> /etc/init.d/rc.local

echo '#!/bin/sh' > /tmp/rc_local_script.sh
echo 'echo -1 > /proc/$(pgrep xray)/oom_score_adj' >> /tmp/rc_local_script.sh
echo 'exit 0' >> /tmp/rc_local_script.sh
mv /tmp/rc_local_script.sh /etc/rc.local
chmod +x /etc/rc.local

/etc/init.d/rc.local enable
/etc/init.d/rc.local start
