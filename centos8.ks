#version=RHEL8
ignoredisk --only-use=vda
# Partition clearing information
clearpart --all --initlabel --drives=vda
skipx
text
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=enp1s0 --ipv6=auto --activate
network  --hostname=localhost.localdomain
# Use network installation
url --url="http://mirror.init7.net/centos/8/BaseOS/x86_64/os/"
repo --name=appstream --baseurl=http://mirror.init7.net/centos/8/AppStream/x86_64/os/

# Root password
rootpw --iscrypted $6$9omOOLnWJHfchqXV$wFxSN8ke0GQQh9RkEaOhbZInM5QS3pc59O1t.NNqmCTsuyaKTfpLiTjIbDEuePvzffbNzt.Qh3WuWJBr8hRnC/
# Run the Setup Agent on first boot
firstboot --enable
# Do not configure the X Window System
skipx
# System services
services --enabled="chronyd"
# System timezone
timezone Europe/Amsterdam --isUtc
# Disk partitioning information
part pv.684 --fstype="lvmpv" --ondisk=vda --grow
part /boot --fstype="ext4" --ondisk=vda --size=976 --label=boot
volgroup cl --pesize=4096 pv.684
logvol / --fstype="xfs" --size=15000 --label="root" --name=root --vgname=cl
logvol /home --fstype="xfs" --size=1000 --label="home" --name=home --vgname=cl
logvol /var/log --fstype="xfs" --size=1000 --label="log" --name=log --vgname=cl
logvol /appl --fstype="xfs" --size=1000 --label="appl" --name=appl --vgname=cl

%packages
@^minimal-environment
@guest-agents

%end

%addon com_redhat_kdump --disable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

%post
mkdir -m0700 /root/.ssh/
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTpTdg9yrHiPFroAVd0kBoSErdX/ztP7YpeDlPJnGhZ bofh@dev.null" > /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
restorecon -R /root/.ssh/
echo "alias vim=vi" > /etc/profile.d/vim.sh
%end
