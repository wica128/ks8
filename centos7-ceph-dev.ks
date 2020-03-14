lang en_US
keyboard us
timezone Europe/Amsterdam --isUtc
rootpw $1$nIIshhNp$rG5vMbhjke2K4WNye1qvc. --iscrypted
#platform x86, AMD64, or Intel EM64T
#reboot
text
url --url=http://mirror.centos.org//centos/7/os/x86_64/
bootloader --location=mbr --append="rhgb quiet crashkernel=auto"
zerombr
clearpart --all --initlabel
autopart
auth --passalgo=sha512 --useshadow
selinux --permissive
firewall --enabled --ssh
skipx
firstboot --disable
%packages
@base
%end