# Kickstart for Centos8
## Update CentOS Install ISO
To use kickstart, we need to update isolinux.cfg


Change the kickstart location in update_centos8_bootiso.sh, to te location of your kickstart file.

Execute: update_centos8_bootiso.sh

This will download the latest  Centos-8-*-boot.iso and creates Custom-Centos-8-*-boot.iso.

Now you can boot from the Custom-Centos-8-*-boot.iso, it will start the automated installation.