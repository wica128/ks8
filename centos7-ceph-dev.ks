lang en_US
keyboard us
timezone Europe/Amsterdam --isUtc
rootpw $1$nIIshhNp$rG5vMbhjke2K4WNye1qvc. --iscrypted
user --name=ceph --iscrypted --password=$6$PiTzp/m2i8z0jGcD$O.7xegRncexuBFP5/z/5wNqSJeT3JIT0JliUbnAkd.W2Sa8kyxiBN5FS2ilGfwIsU/ZKqL5Ok8qVGPnsXUq2t/ --shell=nologin
#platform x86, AMD64, or Intel EM64T
#reboot
text
url --url=http://mirror.centos.org//centos/7/os/x86_64/
services --enabled="chronyd"
zerombr
bootloader --location=mbr --boot-drive=vda
# Partition clearing information
clearpart --all --initlabel --drives=vda
# Disk partitioning information
part /boot --fstype="xfs" --ondisk=vda --size=512 --label=boot
part pv.481 --fstype="lvmpv" --ondisk=vda --size=9727
volgroup system --pesize=4096 pv.481
logvol /  --fstype="xfs" --size=5120 --label="root" --name=root --vgname=system
logvol /mnt/osd001  --fstype="xfs" --size=20 --label="osd001" --name=osd001 --vgname=system
logvol /tmp  --fstype="xfs" --size=512 --label="tmp" --name=tmp --vgname=system



auth --passalgo=sha512 --useshadow
selinux --permissive
firewall --enabled --ssh
skipx
firstboot --disable


%packages
@^minimal
@core
chrony

%end

%addon com_redhat_kdump --disable --reserve-mb='auto'

%end


%post
echo "alias vim=vi" > /etc/profile.d/vim.sh
rpm -Uhv https://download.ceph.com/rpm-nautilus/el7/noarch/ceph-release-1-1.el7.noarch.rpm
yum update -y && sudo yum install ceph-deploy -y
%end