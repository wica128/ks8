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
network  --hostname=tmp-centos7.localdomain
# Use network installation
url --url="http://mirror.centos.org/centos/7/os/x86_64/"

# Root password
rootpw --iscrypted $6$9omOOLnWJHfchqXV$wFxSN8ke0GQQh9RkEaOhbZInM5QS3pc59O1t.NNqmCTsuyaKTfpLiTjIbDEuePvzffbNzt.Qh3WuWJBr8hRnC/
# Run the Setup Agent on first boot
#firstboot --enable

# System services
# System timezone
timezone Europe/Amsterdam --isUtc
# Disk partitioning information
part /boot --fstype="ext4" --ondisk=vda --size=512 --label=boot
part pv.684 --fstype="lvmpv" --ondisk=vda --grow
volgroup vg-root --pesize=4096 pv.684
logvol / --fstype="xfs" --size=8000 --label="root" --name=root --vgname=vg-root
logvol /tmp --fstype="xfs" --size=512 --label="tmp" --name=tmp --vgname=vg-root

%packages
@^minimal-environment
@guest-agents
yum-utils
%end



%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

%post
# SSH Key
mkdir -m0700 /root/.ssh/
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTpTdg9yrHiPFroAVd0kBoSErdX/ztP7YpeDlPJnGhZ bofh@dev.null" > /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
restorecon -R /root/.ssh/

# I like vim 
echo "alias vim=vi" > /etc/profile.d/vim.sh
# Disable selinux :(
sed -i /etc/sysconfig/selinux -e 's/SELINUX=.*/SELINUX=disabled/'
%end
