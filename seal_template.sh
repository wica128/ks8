#!/bin/bash
set -e

RMFILES="/etc/udev/rules.d/70-*
/etc/ssh/ssh_host_*
/etc/sysconfig/network-scripts/ifcfg-eth*
/tmp/*
/var/tmp/*
/var/log/sa/*
/var/log/*-[0-9][0-9]* /var/log/*.gz
/var/log/dmesg.old
/var/log/anaconda
/root/.ssh/
/root/*-ks.cfg
/etc/yum.repos.d/*"

CLEARFILES="/var/log/messages
/var/log/yum.log
/var/log/secure
/var/log/cron
/var/log/maillog
/var/log/audit/audit.log
/var/log/wtmp
/var/log/lastlog
/var/log/grubby"

# Remove old kernels
dnf remove --oldinstallonly --setopt installonly_limit=2

# Cleanup yum
yum clean all

# Remove files
for file in $RMFILES
do
	echo rm -rf $file

done

# Empty files
for file in $CLEARFILES
do
	truncate --size=0 $file
done


/usr/sbin/logrotate -f /etc/logrotate.conf
find /home/ -type d | grep -v "lost+found" | sed '1d' | xargs rm -rf

/bin/rm -f /root/.bash_history
unset HISTFILE

echo "Ready to poweroff"
