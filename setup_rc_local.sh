#!/bin/sh
touch /etc/rc.local
chmod +x /etc/rc.local
echo "exit 0" >> /etc/rc.local
/etc/init.d/rc.local enable
/etc/init.d/rc.local start
echo '#!/bin/sh' > /tmp/rc_local_script.sh
echo 'echo -1 > /proc/$(pgrep xray)/oom_score_adj' >> /tmp/rc_local_script.sh
echo 'exit 0' >> /tmp/rc_local_script.sh
mv /tmp/rc_local_script.sh /etc/rc.local
chmod +x /etc/rc.local
/etc/init.d/rc.local enable
/etc/init.d/rc.local start
