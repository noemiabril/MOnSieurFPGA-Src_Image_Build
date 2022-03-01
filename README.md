# MOnSieurFPGA Image Creation

- Follow these steps to create an SD Image that will run Arch Linux with MiSTerFPGA binaries. Source files taken from the [**MiSTerArch**](https://github.com/amstan/MiSTerArch) repository. Preinstall packages are built from AUR PKGBUILDS.

- This repository is for spinning your own SD Image of MOnSieurFPGA, if you choose not to build from source then a spun image is provided [**here**](https://github.com/MOnSieurFPGA/MOnSieurFPGA-SD_Image_Builds).

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
      sudo cp -r fstab /mountdir2/etc/fstab
      sudo cp -r logo /mountdir2/home/alarm/
      sudo cp -r setup.sh /mountdir2/home/alarm/
      sudo cp -r packages /mountdir2/home/alarm/
      sudo cp -r preinstall /mountdir2/home/alarm/
      sudo cp -r MiSTer.ini /mountdir2/home/alarm/
      sudo udisksctl loop-delete -b /dev/loopX 
      
## SD Card Setup

After creating an image from source, write the image with [**balena-io/etcher**](https://github.com/balena-io/etcher). Boot the DE10-Nano with your newly created sd card; with a wired internet connection. Follow these steps on your local machine:

**Username/Password**:

**LOCAL:**  alarm/alarm  **ROOT:**  root/root
      
    ssh alarm@your.device.ip (use alarm password)
    su (use root password)
    ./setup.sh

Follow the prompts from `setup.sh`. Answer yes to all prompts. Once completed, you will see the `menu.rbf` for MiSTerFPGA displayed over an HDMI connection or 15KHz source. Source rom files for the `/media/fat/games` directory from local, attached, or cifs. Now you're playing with power!

   **Notes:**
   - **The  `MiSTer`  binary location is  now **`/user/bin`**  and  **`menu.rbf`**  is located in `/boot/`. The `menu.rbf` is also copied to `/media/fat/`.**
   
   - **Do not edit files in the `/MiSTer/` directory when the SD card is in your DE10-Nano. Instead, use `/media/fat/` only.**
   
   - **Fast USB polling (1000Hz) is enabled by default in `/boot/uboot.txt`.**

## Licensing

Follow the GPLv3 license attached.


