#!/bin/bash

cat logo/logo ;

echo "/MiSTer	/media/fat	ciopfs	allow_other,default_permissions,use_ino,attr_timeout=0	0	0" | tee -a /etc/fstab ;

echo "SystemMaxUse=20M" | tee -a /etc/systemd/journald.conf ;

echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" | tee -a /etc/sudoers ;

echo "[monsieur]" | tee -a /etc/pacman.conf ;
echo "SigLevel = Optional TrustAll" | tee -a /etc/pacman.conf ;
echo "Server = https://github.com/MOnSieurFPGA/MOnSieurFPGA-Packages/releases/download/Packages" | tee -a /etc/pacman.conf ;

journalctl --vacuum-size=1M ;

pacman-key --init ;

pacman-key --populate archlinuxarm ;

pacman -Sy rsync lockfile-progs ;

pacman -U preinstall/* ;

systemctl enable log2ram ;

systemctl restart log2ram ;

mkdir /MiSTer ;

growpart /dev/mmcblk0 3 ;

resize2fs /dev/mmcblk0p3 ;

pacman -U  --overwrite "*" pkg/* ;

pacman -Syuu ;

mkdir -p /media/fat ;

ciopfs /MiSTer /media/fat ;

pacman -Syu exfat-utils git go-ipfs networkmanager bluez bluez-utils sudo wget unzip bash cifs-utils ;

usermod -aG wheel alarm ;

rm -rf /media/fat/* ;

pacman -Sy JTFPGA-MiSTer MiSTer-devel --overwrite "*" ;

systemctl enable MiSTer ;

systemctl restart MiSTer ;

cp MiSTer.ini /media/fat ;

######## UNCOMMENT THESE BELOW IF NOT USING CIOPFS MOUNT IN FSTAB
# mv /media/fat/Shadow_Masks /media/fat/shadow_masks ;
# mv /media/fat/Presets /media/fat/presets ;
# mv /media/fat/Cheats /media/fat/cheats ;
# mv /media/fat/Filters /media/fat/filters ;
# mv /media/fat/Filters_Audio /media/fat/filters_audio ;
# mv /media/fat/Gamma /media/fat/gamma ;

chown -R alarm /media/fat ;

systemctl enable NetworkManager ;

systemctl restart NetworkManager ;

systemctl enable bluetooth ;

systemctl restart bluetooth ;

echo "Finished! Restarting in 2 seconds, have fun!" ;

sleep 2 ;

reboot





