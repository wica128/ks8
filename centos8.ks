#version=RHEL8
ignoredisk --only-use=vda
# Partition clearing information
clearpart --all --initlabel --drives=vda
# Use graphical install
graphical
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=enp1s0 --ipv6=auto --activate
network  --hostname=localhost.localdomain
# Root password
rootpw --iscrypted $6$9omOOLnWJHfchqXV$wFxSN8ke0GQQh9RkEaOhbZInM5QS3pc59O1t.NNqmCTsuyaKTfpLiTjIbDEuePvzffbNzt.Qh3WuWJBr8hRnC/
# Run the Setup Agent on first boot
firstboot --enable
# Do not configure the X Window System
skipx
# System services
services --enabled="chronyd"
# System timezone
timezone America/New_York --isUtc
# Disk partitioning information
part pv.684 --fstype="lvmpv" --ondisk=vda --size=19503
part /boot --fstype="ext4" --ondisk=vda --size=976 --label=boot
volgroup cl --pesize=4096 pv.684
logvol / --fstype="xfs" --size=19500 --label="root" --name=root --vgname=cl

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

