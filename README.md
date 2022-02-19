## MOnSieurFPGA SD Image Creation

 - Follow the steps below to create an SD Image for MiSTerFPGA running Arch Linux. Source files taken from the [MiSTerArch](https://github.com/amstan/MiSTerArch) repository.

### Initial Setup
---
**X is the loop device number assigned by `sudo udisksctl loop-setup`**.

**Bold Text is a hint, not a shell command**

      dd if=/dev/zero of=MOnSieur-DATE.img bs=1M count=2000;
      sudo udisksctl loop-setup -f MOnSieur-DATE.img

### Partition Information & Installation
---
**Partition /dev/loopX using fdisk/cfdisk/gparted with the following options:**

- **Partition 1: 500MB, `exfat`**
- **Partition 2: 3MB, type `a2`**
- **Partition 3: Remaining Size, `ext4`**

      sudo mkfs.exfat -n BOOT /dev/loopXp1
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
