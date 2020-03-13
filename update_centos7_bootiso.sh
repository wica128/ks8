#!/bin/bash

URI="http://ftp.rz.uni-frankfurt.de/pub/mirrors/centos/7/isos/x86_64/CentOS-7-x86_64-NetInstall-1908.iso"
MD5URI="http://ftp.rz.uni-frankfurt.de/pub/mirrors/centos/7/isos/x86_64/sha256sum.txt"
BASENAME=$(basename $URI)
OPISO="/tmp/Custom_$BASENAME"

ISOLOC="/root/$BASENAME"

cd $(dirname $ISOLOC)

curl -s $MD5URI |grep $BASENAME > $ISOLOC.check

if ! sha256sum -c $ISOLOC.check; then
	curl -#  $URI --out $ISOLOC	
	if ! sha256sum -c $ISOLOC.check; then
		echo "SHA265 check failed"
		exit 1
	fi
fi
cd -

yum install -y isomd5sum genisoimage
mkdir /tmp/bootiso /tmp/bootcustom

mount -o loop $ISOLOC /tmp/bootiso

cp -r /tmp/bootiso/* /tmp/bootcustom

umount /tmp/bootiso && rmdir /tmp/bootiso
chmod -R u+w /tmp/bootcustom

#cp /path/to/yourks.cfg /tmp/bootcustom/isolinux/ks.cfg


sed  -i -e 's/append\ initrd\=initrd.img/append initrd=initrd.img\ ks\=https:\/\/raw.githubusercontent.com\/wica128\/ks8\/master\/centos7-ceph-dev.ks/' \
	-e 's/^timeout.*/timeout 100/' \
	-e '/menu default/d' \
	-e '/label linux/a \ \ menu default' \
	/tmp/bootcustom/isolinux/isolinux.cfg

cd /tmp/bootcustom
mkisofs -o $OPISO -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -V "$(blkid $ISOLOC |sed  's/.*LABEL=\"\([a-zA-Z0-9_-]*\).*/\1/')" -R -J -v -T isolinux/. .
implantisomd5 $OPISO
rm -rf /tmp/bootcustom

