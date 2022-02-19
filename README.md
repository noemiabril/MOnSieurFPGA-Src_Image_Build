# MOnSieurFPGA SD Image Creation

Follow these steps to create an SD Image that will run Arch Linux with MiSTerFPGA binaries. Source files taken from the [**MiSTerArch**](https://github.com/amstan/MiSTerArch) repository.

This repository is for spinning your own SD Image of MOnSieurFPGA, if you choose not to build from source then a spun image is provided [**here**](https://github.com/MOnSieurFPGA/MOnSieurFPGA-Image_Build).

**Bold Text is a hint, not a shell command**.

## Initial Setup

`X` is the loop device number assigned by `sudo udisksctl loop-setup`.

      dd if=/dev/zero of=MOnSieur-DATE.img bs=1M count=2000;
      sudo udisksctl loop-setup -f MOnSieur-DATE.img

## Partition Information & Image Creation
**Partition /dev/loopX using fdisk/cfdisk/gparted with the following options:**

- **Partition 1: 500MB, `fat32`**
- **Partition 2: 3MB, type `a2`**
- **Partition 3: Remaining Size, `ext4`**

      sudo mkfs.vfat -n BOOT /dev/loopXp1
      sudo mkfs.ext4 /dev/loopXp3
      sudo mount /dev/loopXp1 /mountdir1
      sudo mount /dev/loopXp3 /mountdir2
      unzip boot.zip
      sudo cp -r boot/* /mountdir1/
      sudo dd if=boot/uboot.img of=/dev/loopXp2
      rm -rf boot*
      wget http://mirror.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz
      sudo tar xzvpf ArchLinuxARM-armv7-latest.tar.gz -C /mountdir2/
      rm ArchLinuxARM-armv7-latest.tar.gz
      sudo cp -r logo /mountdir2/home/alarm/
      sudo cp -r setup.sh /mountdir2/home/alarm/
      sudo cp -r packages /mountdir2/home/alarm/
      sudo cp -r preinstall /mountdir2/home/alarm/
      sudo cp -r MiSTer.ini /mountdir2/home/alarm/
      sudo udisksctl loop-delete -b /dev/loopX 
      
## SD Card Setup

After creating an image from source, write the image with [**balena-io/etcher**](https://github.com/balena-io/etcher). Boot the DE10-Nano with your newly created sd card; with a wired internet connection. Follow these steps on your local machine:

> ***Username/Password**:*
> 
> 	*Local*: **alarm/alarm** 	*ROOT*: **root/root**
> 
>  - `ssh alarm@your.device.ip`
>  - `su` 
>  - `./setup.sh`

Follow the prompts from `setup.sh`. Answer yes to all prompts. Once completed, you will see the `menu.rbf` for MiSTerFPGA displayed over an HDMI connection or 15KHz source. Source rom files for the `/media/fat/games` directory from local, attached, or cifs. Now you're playing with power!

Note: `MiSTer` binary and `menu.rbf` are no longer located in `/media/fat`. The `MiSTer` binary is located in `/user/bin` and `menu.rbf` is located in `/boot/`.

## Licensing

Follow the GPLv3 license attached.


