---
title: Managing the Linux kernel configuration
tags:
  - Buildroot
  - Kernel
---

In the Kernel menu in menuconfig, after selecting the kernel version, you have two options to deﬁne the kernel conﬁguration:

- Use a defconfig
  - use the defconfig provided within the kernel sources,available in `arch/<ARCH>/configs`
  - use a custon config files
  - Additional fragments
### changing the configuration

Running one of the linux kernel configuration interfaces:
- make linux-menuconfig
- make linux-nconfig
- make linux-xconfig
- make linux-gconfig

Changes made are only in `$(O)/build/linux-<version>/`, Can use below commands to save them:
- make linux-update-config, to save a full config file
- make linux-update-deconfig, to save a minimal defconfig

Typical flow

- make linux-menuconfig
- do the build, test, tweak the configuration as needed.
- change kernel configuration to using a custom (def)config file and set the Configuration file path.
- run make linux-update-defconfig
