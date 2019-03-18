---
title: Root filesystem in Buildroot
tags:
  - Buildroot
  - Rootfs
---

Overall rootfs construction steps

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-12-31-000745.jpg)

# Root filesystem skeleton

- Copy the skeleton package to $(target_dir) at the beginning of the build.
- skeleton is a virtual package that will depend on:
  - skeleton-init-{sysv,systemd,none} depending on the init system being selected skeleton-custom when a custom skeleton is selected
- All of skeleton-init-{sysv,systemd,none} depend on skeleton-init-common
  - Copies system/skeleton/* to $(TARGET_DIR)
- skeleton-init-{sysv,systemd} install additional ﬁles speciﬁc to those init systems
- Custom root ﬁlesystem skeleton
  - A custom skeleton can be used, through the BR2_ROOTFS_SKELETON_CUSTOM and BR2_ROOTFS_SKELETON_CUSTOM_PATH options.
  - In this case: skeleton depends on skeleton-custom
  - Completely replaces skeleton-init-*, so the custom skeleton must provide everything.

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-12-31-002946.jpg)

# Installation of packages

- All the selected target packages will be built (can be Busybox, Qt, OpenSSH, lighttpd, and many more)
- Most of them will install ﬁles in $(TARGET_DIR): programs, libraries, fonts, data ﬁles, conﬁguration ﬁles, etc.
- This is really the step that will bring the vast majority of the ﬁles in the root ﬁlesystem.
- Covered in more details in the section about creating your own Buildroot packages.

# Cleanup step

- Once all packages have been installed, a cleanup step is executed to reduce the size of the root ﬁlesystem.
- It mainly involves:
  - Removing header ﬁles, pkg-conﬁg ﬁles, CMake ﬁles, static libraries, man pages, documentation.
  - Stripping all the programs and libraries using strip, to remove unneeded information. Depends on BR2_ENABLE_DEBUG and BR2_STRIP_* options.
  - Additional speciﬁc clean up steps: clean up unneeded Python ﬁles when Python is used, etc. See TARGET_FINALIZE_HOOKS in the Buildroot code.
# Root ﬁlesystem overlay

- To customize the contents of your root ﬁlesystem, to add conﬁguration ﬁles, scripts, symbolic links, directories or any other ﬁle, one possible solution is to use a root ﬁlesystem overlay.
- A root ﬁlesystem overlay is simply a directory whose contents will be copied over the root ﬁlesystem, after all packages have been installed. Overwriting ﬁles is allowed.
- The option BR2_ROOTFS_OVERLAY contains a space-separated list of overlay paths.

# Post-build scripts

- Sometimes a root ﬁlesystem overlay is not suﬃcient: you can use post-build scripts.
- Can be used to customize existing ﬁles, remove unneeded ﬁles to save space, add new ﬁles that are generated dynamically (build date, etc.)
- Executed before the root ﬁlesystem image is created. Can be written in any language, shell scripts are often used. BR2_ROOTFS_POST_BUILD_SCRIPT contains a space-separated list of post-build script paths.
- $(TARGET_DIR) path passed as ﬁrst argument, additional arguments can be passed in the BR2_ROOTFS_POST_SCRIPT_ARGS option.
- Various environment variables are available:
  - BR2_CONFIG, path to the Buildroot .conﬁg ﬁle
  - HOST_DIR, STAGING_DIR, TARGET_DIR, BUILD_DIR, BINARIES_DIR, BASE_DIR


# Generating the ﬁlesystem images

- In the Filesystem images menu, you can select which ﬁlesystem image formats to generate.
- To generate those images, Buildroot will generate a shell script that:
 - Changes the owner of all ﬁles to 0:0 (root user) Takes into account the global permission and device tables, as well as the per-package ones.
 - Takes into account the global and per-package users tables.
 - Runs the ﬁlesystem image generation utility, which depends on each ﬁlesystem type (genext2fs, mkfs.ubifs, tar, etc.)

- This script is executed using a tool called fakeroot
 - Allows to fake being root so that permissions and ownership can be modiﬁed, device ﬁles can be created, etc.
 - Advanced: possibility of running a custom script inside fakeroot, see BR2_ROOTFS_POST_FAKEROOT_SCRIPT.

## Permission table

- By default, all ﬁles are owned by the root user, and the permissions with which they are installed in $(TARGET_DIR) are preserved.

- To customize the ownership or the permission of installed ﬁles, one can create one or several permission tables
- BR2_ROOTFS_DEVICE_TABLE contains a space-separated list of permission table ﬁles. The option name contains device for backward compatibility reasons only.
- The system/device_table.txt ﬁle is used by default.

## Device table
- When the system is using a static /dev, one may need to create additional device nodes
- Done using one or several device tables BR2_ROOTFS_STATIC_DEVICE_TABLE contains a space-separated list of device table ﬁles.
- The system/device_table_dev.txt ﬁle is used by default.
- Packages can also specify their own device ﬁles. See the Advanced package aspects section for details.

## Users table

- One may need to add speciﬁc Unix users and groups in addition to the ones available in the default skeleton.
- BR2_ROOTFS_USERS_TABLES is a space-separated list of user tables.
- Packages can also specify their own users. See the Advanced package aspects section for details.

# Post-image scripts

- Once all the ﬁlesystem images have been created, at the very end of the build, post-image scripts are called.
- They allow to do any custom action at the end of the build. For example:
 - Extract the root ﬁlesystem to do NFS
 - booting Generate a ﬁnal ﬁrmware image
 - Start the ﬂashing process
- BR2_ROOTFS_POST_IMAGE_SCRIPT is a space-separated list of post-image scripts to call.
- Post-image scripts are called:
 - from the Buildroot source directory
 - with the $(BINARIES_DIR) path as ﬁrst argument
 - with the contents of the BR2_ROOTFS_POST_SCRIPT_ARGS as other arguments
 - with a number of available environment variables: BR2_CONFIG, HOST_DIR, STAGING_DIR, TARGET_DIR, BUILD_DIR, BINARIES_DIR and BASE_DIR.

## Init mechanism
- Buildroot supports multiple init implementations:
  - Busybox init, the default. Simplest solution.
  - sysvinit, the old style featureful init implementation
  - systemd, the new generation init system

- Selecting the init implementation in the System configuration menu will:
 - Ensure the necessary packages are selected
 - Make sure the appropriate init scripts or conﬁguration ﬁles are installed by packages.


## /dev management method

- Buildroot supports four methods to handle the /dev directory:

  - Using devtmpfs. /dev is managed by the kernel devtmpfs, which creates device ﬁles automatically. Requires kernel 2.6.32+. Default option.
  - Using static /dev. This is the old way of doing /dev, not very practical.
  - Using mdev. mdev is part of Busybox and can run custom actions when devices are added/removed. Requires devtmpfs kernel support.
  - Using eudev. Forked from systemd, allows to run custom actions. Requires devtmpfs kernel support.
- When systemd is used, the only option is udev from systemd itself.

## Other customization options

- There are various other options to customize the root ﬁlesystem:
  - getty options, to run a login prompt on a serial port or screen
  - hostname and banner options
  - DHCP network on one interface (for more complex setups, use an overlay)
  - root password
  - timezone installation and selection
  - locale ﬁles installation and ﬁltering (to install translations only for a subset of languages, or none at all)

## Deploying the images
By default, Buildroot simply stores the diﬀerent images in $(O)/images. It is up to the user to deploy those images to the target device. Possible solutions:


- For removable storage (SD card, USB keys):
 - manually create the partitions and extract the root ﬁlesystem as a tarball to the appropriate partition.
 - use a tool like genimage to create a complete image of the media, including all partitions

- For NAND ﬂash:
  - Transfer the image to the target, and ﬂash it.

- NFS booting
- initramfs
## Deploying the images: genimage
- genimage allows to create the complete image of a block device (SD card, USB key, hard drive), including multiple partitions and ﬁlesystems.
- For example, allows to create an image with two partition: one FAT partition for bootloader and kernel, one ext4 partition for the root ﬁlesystem.
- Also allows to place the bootloader at a ﬁxed oﬀset in the image if required.
- The helper script support/scripts/genimage.sh can be used as a post-image script to call genimage
- More and more widely used in Buildroot default conﬁgurations


## Deploying the image: NFS booting

- Many people try to use $(O)/target directly for NFS booting
- This cannot work, due to permissions/ownership being incorrect Clearly explained in the THIS_IS_NOT_YOUR_ROOT_FILESYSTEM ﬁle.
- Generate a tarball of the root ﬁlesystem
- Use sudo tar -C /nfs -xf output/images/rootfs.tar to prepare your NFS share.

## Deploying the image: initramfs

- Another common use case is to use an initramfs, i.e. a root ﬁlesystem fully in RAM.
- Convenient for small ﬁlesystems, fast booting or kernel development
- Two solutions:
 - BR2_TARGET_ROOTFS_CPIO=y to generate a cpio archive, that you can load from your bootloader next to the kernel image.
 - BR2_TARGET_ROOTFS_INITRAMFS=y to directly include the initramfs inside the kernel image. Only available when the kernel is built by Buildroot.
