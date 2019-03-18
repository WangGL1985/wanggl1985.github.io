---
title: buildroot 学习/实践记录（一）
date: 2017-12-25 22:22:12
updated:
tags:
  - Buildroot
  - linux
---
Buildroot 是一个包含 Makefile 和 Patch 程序的集合，这个集合可以使你很容易的为你的目标构建交叉工具链，根文件系统、Linux 内核映像以及 bootloader。Buildroot 可以独立的实现其中的一个或几个功能。详细信息请参阅 [Wikipedia](https://en.wikipedia.org/wiki/Buildroot)。


<!-- more -->

Buildroot 的主要目标：
- 使用简单
- 定制方便
- 可重复性
- 快速启动
- 易于理解

Buildroot 按年发布 LTS 版本。

# 实验一：准备实验环境

## Install lab data

```shell
cd ~
mkdir emLinux
cd ~/emLinux
wget http://free-electrons.com/doc/training/buildroot/buildroot-labs.tar.xz
tar xvf buildroot-labs.tar.xz
```

## Install extra packages
```shell
cd ~/emLinux/buildroot-labs/
sudo apt-get install sed make binutils gcc g++ bash patch \
gzip bzip2 perl tar cpio python unzip rsync wget libncurses-dev
```

# Linux 系统架构
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-12-25-144030.jpg)
# Linux 启动流程
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-12-25-144507.jpg)
# 构建系统的方式及对比

|              | 优点                                    | 缺点                                           |
|:-------------|:----------------------------------------|:-----------------------------------------------|
| 从手工构建   | 灵活性高</br> 学到更多的经验            | 各模块的依赖复杂</br>版本兼容问题</br>重复性低 |
| 使用发行版   | 使用方便，易于扩展                      | 定制困难</br>优化困难</br>...                  |
| 使用构建工具 | 灵活性高、方便定制和优化</br>重复性高、 |                                                |

# 使用 Buildroot

```shell
cd buildroot/
make help
```
需要注意一个概念 --『构建目录』，在任何使用 make 构建的目录下，都建议首先运行 `make help` 查看帮助信息。

## 配置 buildroot

buildroot 配置工具为 Kconfig， 有多种配置接口：
- make menuconfig
- make nconfig
- make xconfig
- make gconfig

使用方法大同小异，不同接口使用的底层库不同( ncurses for menuconfig/nconfig, Qt for xconfig, Gtk for gconfig )，通常开发机器多运行服务器，工作机用 `ssh` 联机，所以使用 `make menuconfig` 居多。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-12-25-151550.jpg)

只推荐一种构建命令格式： `make 2>&1 | tee build.log`。

buildroot 的所有构建结果都保存在构建目录下的 **`output`** 中。依据配置，该目录下(buildroot/output)通常包含：
- 一个或多个不同格式的文件系统
- 内核镜像和一个或多个设备树
- 一个或多个 bootloader


# 实验二： 构建简单系统

## 下载 Buildroot 源码

```shell
git clone git://busybox.net/buildroot
git checkout -b felabs 2017.08
git branch
```
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-12-25-152720.jpg)
## Configuring Buildroot

```shell
make menuconfig
```

- Target Options
  - Target Architecture ARM (little endian)
  - Target Architecture Variant (cortex-A8)
  - Target ABI (EABIhf)
  - Target Binary Format (ELF)
- Build options
- Toolchain
   -  Toolchain type (External toolchain)
   -  Toolchain (Linaro ARM 2017.02)
- System configuration
- Kernel menu
   - Enable the linux kernel
   - Kernel version (Custom version) 4.13
   - Kernel configuration (Using an in-tree defconfig file) --->
   - Defconfig name (omap2plus)
   - Kernel binary format (zImage)
   - Build a Device Tree Blob(DTB)
     - Device tree source (Use a device tree present in the kernel)
     - Device Tree Source file names (`am335x-boneblack`)
- Target packages
- Filesystem images ( tar the root filesystem )
- Bootloader
   - U_Boot
   - Build system (Kconfig)
   - U-Boot Version 2017.07.
   - U-Boot configuration (Using an in-tree board defconfig file)--->
   - Board defconfig (am335x_boneblack)
   - Install U-Boot SPL binary image
     - U-Boot SPL binary image name (MLO)
   - U-Boot binary format (u-boot.img)

整个配置过程中应该多查看帮助信息，以便多了解各个配置项的具体含义。

## Building

```shell
make 2>&1 | tee build.log
```
## Prepare the SD card

- The first partition for the bootloader (FAT16)

  - MLO
  - u-boot.img
  - zImage
  - am335x-boneblack.dtb
  - U-Boot script
- The second partition for the root filesystem(ext4).
- To format our SD card
  - Unmount all partitions of your SD card
  - `sudo dd if=/dev/zero of=/dev/sdb bs=1M count=16`
  - Create the two partitions
    - `sudo cfdisk /dev/sdb`
    - Chose the dos partition table type
    - Create a first small partition, **primary**, with type **e** (W95,FAT16) and mark it **bootable**
    - Create a second partition, **primary**,83(Linux)
    - Exit cfdisk
  - `sudo mkfs.vfat -F 16 -n boot /dev/sdb1`
  - `sudo mkfs.ext4 -L rootfs -E nodiscard /dev/sdb2`


## Flash the system

- `cp MLO /Media/boot`

- `cp u-boot.img /Media/boot`

- ....

- `sudo tar -C /media/<user>/rootfs/ -xf output/images/rootfs.tar`

- Create a file named uEnv.txt in the boot partition

  ```shell
  bootdir=
  bootpart=0:1
  devtype=mmc
  args_mmc=setenv bootargs console=${console} ${optargs} root=/dev/sdb2 rw rootfstype=${mmcrootfstype}
  uenvcmd=run loadimage;run loadramdisk;run findfdt;run loadfdt;run mmcloados
  ```

  ​

## Boot the system

```shell
env default -f -a
saveenv
```



## Explore the build log

```shell
grep ">>>" build.log
```
