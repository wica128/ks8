if [ -z $1 ]; then
	echo "Please provide a iso"
	exit 1
fi

if [ ! $1 ];then
	echo "ISO not found"
	exit 1
fi


OPISO="custum_centos8_boot.iso"

URI="http://yum.tamu.edu/centos/8/isos/x86_64/CentOS-8.1.1911-x86_64-boot.iso"
curl $URI --out /tmp/boot.iso

yum install -y isomd5sum genisoimage
mkdir /tmp/bootiso /tmp/bootcustom

mount -o loop /tmp/boot.iso /tmp/bootiso

cp -r /tmp/bootiso/* /tmp/bootcustom
umount /tmp/bootiso && rmdir /tmp/bootiso
chmod -R u+w /tmp/bootcustom

#cp /path/to/yourks.cfg /tmp/bootcustom/isolinux/ks.cfg


sed -i 's/append\ initrd\=initrd.img/append initrd=initrd.img\ ks\=cdrom:\/ks.cfg/' /tmp/bootcustom/isolinux/isolinux.cfg

cd /tmp/bootisoks && \
mkisofs -o /tmp/$OPISO -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -V "CentOS 7 x86_64" -R -J -v -T isolinux/. .
implantisomd5 /tmp/$OPISO
