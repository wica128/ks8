lang en_US
keyboard us
timezone Europe/Amsterdam --isUtc

network  --bootproto=dhcp --device=enp1s0 --ipv6=auto --activate
network  --hostname=ceph-dev.localdomain


rootpw $1$nIIshhNp$rG5vMbhjke2K4WNye1qvc. --iscrypted
user --name=ceph --groups=wheel --iscrypted --password=$6$PiTzp/m2i8z0jGcD$O.7xegRncexuBFP5/z/5wNqSJeT3JIT0JliUbnAkd.W2Sa8kyxiBN5FS2ilGfwIsU/ZKqL5Ok8qVGPnsXUq2t/
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
logvol /tmp  --fstype="xfs" --size=512 --label="tmp" --name=tmp --vgname=system
logvol /mnt/osd001  --fstype="xfs" --size=50 --label="osd001" --name=osd001 --vgname=system
logvol /mnt/osd002  --fstype="xfs" --size=50 --label="osd002" --name=osd002 --vgname=system
logvol /mnt/osd003  --fstype="xfs" --size=50 --label="osd003" --name=osd003 --vgname=system
logvol /mnt/osd004  --fstype="xfs" --size=50 --label="osd004" --name=osd004 --vgname=system
logvol /mnt/osd005  --fstype="xfs" --size=50 --label="osd005" --name=osd005 --vgname=system
logvol /mnt/osd006  --fstype="xfs" --size=50 --label="osd006" --name=osd006 --vgname=system



auth --passalgo=sha512 --useshadow
selinux --permissive
firewall --enabled --ssh
skipx
firstboot --disable


%packages
@^minimal
@core
chrony
python-setuptools
python36
#centos-release-ceph-nautilus
#ceph
%end

%addon com_redhat_kdump --disable --reserve-mb='auto'

%end


%post
mkdir -m0700 /root/.ssh/
echo "ssh-ed25519 aaaac3nzac1lzdi1nte5aaaaidtptdg9yrhipfroavd0kboserdx/ztp7ypedlpjnghz bofh@dev.null" > /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
restorecon -r /root/.ssh/

mkdir -m0700 ~ceph/.ssh/
echo "ssh-ed25519 aaaac3nzac1lzdi1nte5aaaaidtptdg9yrhipfroavd0kboserdx/ztp7ypedlpjnghz bofh@dev.null" > ~ceph/.ssh/authorized_keys
chmod 0600 ~ceph/.ssh/authorized_keys
chown ceph:ceph ~ceph/.ssh/authorized_keys
restorecon -r ~ceph/.ssh/
su ceph -c "yes ''|ssh-keygen"
cat ~ceph/.ssh/id_rsa.pub >> ~ceph/.ssh/authorized_keys

#rpm -Uhv https://download.ceph.com/rpm-nautilus/el7/noarch/ceph-release-1-1.el7.noarch.rpm
#yum update -y && sudo yum install ceph-deploy -y


#su ceph -c "mkdir ~/cluster"
#su ceph -c "cd ~/cluster"



# Really??
yum -y update
%end