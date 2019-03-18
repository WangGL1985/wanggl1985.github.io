---
title: linux kernel
tags:
  - linux
  - kernel
---

# Linux features

- Portability and hardware support. Runs on most architectures.
- Scalability. Can run on super computers as well as on tiny devices.
- Compliance to standards and interoperability.
- Exhaustive networking support
- Security. It can't hide its flaws. Its code is reviewed by many experts.
- Stability and reliability.
- Modularity. Can include only what a system needs even at run time.
- Easy to program. You can learn from existing code. Many useful resources on the net.


## Linux kernel in the system and its components
### linux kernel main roles

- Manage all the hardware resources
- Provide a set of protable, architecture and hardware independent APIs
- Handle concurrent accesses and usage of hardware resources

### system call

- The main interface between the kernel and user space is the set of system call.
- The system call interface is wrapped by the C library, and user space applications usually never make a system call directly but rather use the corresponding C library function

### pseudo filesystems

- Linux makes system and kernel information available in user apace through pseudo filesystems(virtual filesystems)
- Pseudo ﬁlesystems allow applications to see directories and ﬁles that do not exist on any real storage: they are created and updated on the ﬂy by the kernel
- The two most important pseudo ﬁlesystems are
  - proc, usually mounted on /proc
  - sysfs, usually mounted on /sys (Representation of the system as a set of devices and buses. Information about these devices.)


![](http://olkbjcb09.bkt.clouddn.com/blog/2017-12-28-142306.jpg)

# Embedded Linux Kernel Usage

## Linux kernel sources

### Location of kernel sources

- The [official versions](http://www.kernel.org) of the Linux kernel.
- Chip vendors supply their own kernel sources.
- Many kernel sub-communities maintain their own kernel.
  - Architecture communities (ARM, MIPS, PowerPC, etc.)
  - Device drivers communities (I2C, SPI, USB, PCI,network.)
  - other communities (real-time)

### Getting linux sources

- [full tarballs and patches](http://kernel.org/pub/linux/kernel)
- git version `git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git`
- [web interface](http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/)


## Kernel source code

### Programming language

- Implemented in C like all Unix systems.
- A little Assembly us used too
- No C++ used.
- All the code compiled with gcc

### No C library

- The kernel has to be standalone and can't use user space code.
- Kernel code supply its own library implementations
- printk, memset()...

### Portability
### No ﬂoating point computation

**Never use ﬂoating point numbers in kernel code.**

### No stable Linux internal API

### Kernel memory constraints

- No memory protection The kernel doesn't try to recover from attemps to access illegal memory locations. It just dumps oops messages on the system console.
- Fixed size stack (8 or 4 KB). Unlike in user space, no mechanism was implemented to make it grow.
- Swapping is not implemented for kernel memory either.



## User space device drivers

- Drawbacks
  - Less straightforward to handle interrupts.
  - Increased interrupt latency vs. kernel code.

## Linux sources

###  Linux sources structure

- arch/<ARCH>
  - Architecture speciﬁc code
  - arch/<ARCH>/mach-<machine>, machine/board speciﬁc code
  - arch/<ARCH>/include/asm, architecture-speciﬁc headers
  - arch/<ARCH>/boot/dts, Device Tree source ﬁles, for some architectures
- block/
- COPYING
- CREDITS
- crypto/
- Documentation/
- drivers/
- firmware/
- fs/
- include/
- include/linux/
- include/uapi/
- init/
- ipc/
- Kbuild
- Kconfig
- Kernel -- Linux kernel core
- lib/
- MAINTAINERS
- makefile
- mm/
- net/
- README
- sampiles/
- scripts/
- security/
- sound/
- tools/
- usr/
- virt/

### Kernel source management tools


## Kernel conﬁguration

- The kernel contains thousands of device drivers, ﬁlesystem drivers, network protocols and other conﬁgurable items
- Thousands of options are available, that are used to selectively compile parts of the kernel source code
- The kernel conﬁguration is the process of deﬁning the set of options with which you want your kernel to be compiled
- The set of options depends
  - On your hardware (for device drivers, etc.)
  - On the capabilities you would like to give to your kernel (network capabilities, ﬁlesystems, real-time, etc.)
- The conﬁguration is stored in the .config ﬁle at the root of kernel sources (Simple text ﬁle, `key=value` style)
- As options have dependencies, typically never edited by hand, but through graphical or text interfaces:
  - make xconfig, make gconfig (graphical)
  - make menuconfig, make nconfig (text)
  - You can switch from one to another, they all load/save the same .config ﬁle, and show the same set of options
- To modify a kernel in a GNU/Linux distribution: the conﬁguration ﬁles are usually released in `/boot/`, together with kernel images: `/boot/config-3.2.0-31-generic`

### Kernel or module?

- The kernel image is a single ﬁle, resulting from the linking of all object ﬁles that correspond to features enabled in the conﬁguration
  - This is the ﬁle that gets loaded in memory by the bootloader
  - All included features are therefore available as soon as the kernel starts, at a time where no ﬁlesystem exists
- Some features (device drivers, ﬁlesystems, etc.) can however be compiled as modules
  - These are plugins that can be loaded/unloaded dynamically to add/remove features to the kernel
  - **Each module is stored as a separate ﬁle in the ﬁlesystem**, and therefore access to a ﬁlesystem is mandatory to use modules
  - This is not possible in the early boot procedure of the kernel, because no ﬁlesystem is available

### Kernel option types
### Kernel option dependencies
- depends on dependencies. In this case, option A that depends on option B is not visible until option B is enabled
- select dependencies. In this case, with option A depending on option B, when option A is enabled, option B is automatically enabled

## Kernel compilation

- make
  - in the main kernel source directory
  - Remember to run multiple jobs in parallel if you have multiple CPU cores. Example: `make -j 4 `
  - No need to run as root!

- Generates
  - vmlinux, the raw uncompressed kernel image, in the ELF format, useful for debugging purposes, but cannot be booted
  - `arch/<arch>/boot/*Image`, the ﬁnal, usually compressed, kernel image that can be booted
    - bzImage for x86,
    - zImage for ARM,
    - vmImage.gz for Blackﬁn, etc.
  - `arch/<arch>/boot/dts/*.dtb`, compiled Device Tree ﬁles (on some architectures)
  - All kernel modules, spread over the kernel source tree, as .ko (Kernel Object) ﬁles.

## Kernel installation

- make install
  - Does the installation for the host system by default, so needs to be run as root. Generally not used when compiling for an embedded system, as it installs ﬁles on the development workstation.
- Installs
  - /boot/vmlinuz-<version> Compressed kernel image. Same as the one in arch/<arch>/boot
  - /boot/System.map-<version> Stores kernel symbol addresses for debugging purposes (obsolete: such information is usually stored in the kernel itself)
  - /boot/config-<version> Kernel conﬁguration for this version
- Typically re-runs the bootloader conﬁguration utility to take the new kernel into account.


## Module installation

- make modules_install
  - Does the installation for the host system by default, so needs to be run as root

- Installs all modules in ``/lib/modules/<version>/``
  - kernel/  Module .ko (Kernel Object) ﬁles, in the same directory structure as in the sources.
  - `modules.alias, modules.aliases.bin` Aliases for module loading utilities. Used to ﬁnd drivers for devices. Example line: alias usb:v066Bp20F9d*dc*dsc*dp*ic*isc*ip*in* asix
  - modules.dep, modules.dep.bin Module dependencies
  - modules.symbols, modules.symbols.bin Tells which module a given symbol belongs to.

## Kernel cleanup targets

- make clean
- make mrproper
- make distclean
- git clean -fdx

## Cross-compiling the kernel

### Specifying cross-compilation

- ARCH
- CROSS_COMPILE


### Predeﬁned conﬁguration ﬁles

- arch/<arch>/configs/
- make xxx_defconfig
- make savedefconfig

### Conﬁguring the kernel
### Device Tree

- Many embedded architectures have a lot of non-discoverable hardware.
- Depending on the architecture, such hardware is either described using C code directly within the kernel, or using a special hardware description language in a Device Tree.
- ARM, PowerPC, OpenRISC, ARC, Microblaze are examples of architectures using the Device Tree.
- A Device Tree Source, written by kernel developers, is compiled into a binary Device Tree Blob, passed at boot time to the kernel.
  - There is one diﬀerent Device Tree for each board/platform supported by the kernel, available in arch/arm/boot/dts/<board>.dtb.

- The bootloader must load both the kernel image and the Device Tree Blob in memory before starting the kernel.

## Building and installing the kernel
- Run `make` Copy the ﬁnal kernel image to the target storage
  - can be zImage, vmlinux, bzImage in arch/<arch>/boot
  - copying the Device Tree Blob might be necessary as well, they are available in arch/<arch>/boot/dts

- `make install` is rarely used in embedded development, as the kernel image is a single ﬁle, easy to handle
  - It is however possible to customize the make install behaviour in arch/<arch>/boot/install.sh

- `make modules_install` is used even in embedded development, as it installs many modules and description ﬁles
- `make INSTALL_MOD_PATH=<dir>/ modules_install` The **INSTALL_MOD_PATH** variable is needed to install the modules in the target root ﬁlesystem instead of your host root ﬁlesystem.


### Booting with U-Boot
### Kernel command line
- In addition to the compile time conﬁguration, the kernel behaviour can be adjusted with no recompilation using the **kernel command line**
- The kernel command line is a string that deﬁnes various arguments to the kernel
  - It is very important for system conﬁguration
  - `root=` for the root ﬁlesystem (covered later)
  - `console=` for the destination of kernel messages Many more exist.
  - The most important ones are documented in admin-guide/kernel-parameters in kernel documentation.

- This kernel command line is either
  - Passed by the bootloader. In U-Boot, the contents of the `bootargs` environment variable is automatically passed to the kernel
  - Speciﬁed in the Device Tree (for architectures which use it)
  - Built into the kernel, using the CONFIG_CMDLINE option.


## Using kernel modules

- Module dependencies

Dependencies are described both in `/lib/modules/<kernel-version>/modules.dep` and in `/lib/modules/<kernel-version>/modules.dep.bin` These ﬁles are generated when you run `make modules_install`.

- Kernel log

Kernel log messages are available through the dmesg command (**d**iagnostic **mes**sa**g**e)


- Module utilities
  - modinfo <module_name>
  - sudo insmod <module_path>.ko
  - sudo modprobe <module_name>
  - lsmod
  - sudo rmmod <module_name>
  - sudo modprobe -r <module_name>

- Passing parameters to modules
```bash
modinfo usb-storage
sudo insmod ./usb-storage.ko delay_use=0
```

or
```bash
vim /etc/modprobe.conf

options usb-storage delay_use=0
```

- module parameter values

Check `/sys/module/<name>/parameters`, There is one file per parameter, containing the parameter value.

















Training setup

Install lab data

    cd
    wget http://free-electrons.com/doc/training/linux-kernel/linux-kernel-labs.tar.xz
    tar xvf linux-kernel-labs.tar.xz

Install extra packages

Downloading kernel source code

Setup

    mkdir $HOME/emlinux/linux-kernel-labs/src

Installing git packages

    sudo apt-get install git gitk git-email

Git configuration

    git config --global user.name ’WangGL1985’
    git config --global user.email tswanggl@gmail.com

Cloning the mainline Linux tree

    cd ~/emlinux/linux-kernel-labs/src
    git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Accessing stable releases

    cd ~/linux-kernel-labs/src/linux/
    git remote add stable git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
    git fetch stable


Kernel source code

Choose a particular stable version

    cd ~/linux-kernel-labs/src/linux
    git branch -a
    git checkout -b 4.9.y stable/linux-4.9.y

Exploring the sources manually

1. Find the Linux logo image in the sources 1 .
2. Find who the maintainer of the MVNETA network driver is.
3. Find the declaration of the platform_device_register() function.
   git grep platform_device_register()  much fast

Use a kernel source indexing tool

http://elixir.free-electrons.com

Board setup

Getting familiar with the board

Download technical documentation

Setting up serial communication with the board

sudo apt-get install picocom

Bootloader interaction

clear the env variables

    env default -f -a
    saveenv

Setting up Ethernet communication

On development workstation:

    sudo apt-get install tftpd-hpa

IPv4 settings

In the IPv4 Settings tab, choose the Manual method to make the interface use a static IP

address, like 192.168.0.1

You can use 24 as Netmask, and leave the Gateway field untouched.

on board

    setenv ipaddr 192.168.12.105
    setenv serverip 192.168.12.1
    saveenv

You can then test the TFTP connection. First, put a small text file in /var/lib/tftpboot.

Then, from U-Boot, do:

    tftp 0x81000000 textfile.txt

dumping the contents of the memory:

    md 0x81000000

Kernel compiling and booting

Setup

    cd ~/emLinux/linux-kernel-labs/src/linux-stable
    sudo apt-get install qt5-default g++ pkg-config

Cross-compiling toolchain setup

    sudo apt-get install gcc-arm-linux-gnueabi
    dpkg -L gcc-arm-linux-gnueabi

Kernel configuration

CONFIG_ROOT_NFS=y

Kernel compiling

make -j 4

copy the zImage and am335x-boneblack.dtb files to the TFTP server home directory

(/var/lib/tftpboot).

Setting up the NFS server

    vim /etc/exports
    /home/<user>/linux-kernel-labs/modules/nfsroot 192.168.0.100(rw,no_root_squash,no_subtree_check)

192.168.0.100 is the board ip address

    sudo /etc/init.d/nfs-kernel-server restart

Boot the system

    setenv bootargs root=/dev/nfs rw ip=192.168.0.100 console=ttyO0 nfsroot=192.168.0.1:/home/<user>/linux-kernel-labs/modules/nfsroot

    saveenv

    editenv bootargs

    tftp 0x81000000 zImage
    tftp 0x82000000 am335x-boneblack.dtb
    bootz 0x81000000 - 0x82000000

Checking the kernel version

There are two ways of checking your kernel version:

- By looking at the first kernel messages
- By running the uname -a command after booting Linux.

Automate the boot process

    setenv bootcmd 'tftp 0x81000000 zImage; tftp 0x82000000 am335x-boneblack.dtb; bootz 0x81000000 - 0x82000000'
    saveenv

Writing modules

Setup

    cd ~/linux-kernel-labs/modules/nfsroot/root/hello
    vim hello_version.c



Building your module

    make

Testing your module

Adding a parameter to your module

    vim hello_version.c
    change Master --> <who>

Adding time information

using do_gettimeofday()

Following Linux coding standards

Adding the hello_version module to the kernel sources

Create a kernel patch
