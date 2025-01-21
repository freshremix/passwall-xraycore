#!/bin/sh

echo 1 > /proc/sys/vm/overcommit_memory
echo 10 > /proc/sys/vm/swappiness
echo "vm.overcommit_memory = 1" >> /etc/sysctl.d/99-custom.conf
echo "vm.swappiness = 10" >> /etc/sysctl.d/99-custom.conf
if ! grep -q "echo 1 > /proc/sys/vm/overcommit_memory" /etc/rc.local; then
    sed -i '/exit 0/i\
echo 1 > /proc/sys/vm/overcommit_memory\n\
echo 10 > /proc/sys/vm/swappiness' /etc/rc.local
fi
cat /proc/sys/vm/overcommit_memory
cat /proc/sys/vm/swappiness
