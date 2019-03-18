---
title: buldroot 学习/实践记录(二) -- Buildroot 目录分析
tags:
  - Buildroot
  - linux
---

# Buildroot 目录结构

> The top-level Buildroot source directory -- buildroot, 对应变量 $(TOPDIR)

- 构建的所有文件都保存在 `buildroot/output` 目录， 可由 `O` 作为 `make` 的参数指定
- 所有的配置选项保存在 `buildroot/.config` ，
  - `CONFIG_DIR = $(TOPDIR)`
  - TOPDIR = $(shell pwd)
- buildroot/
  - .config
  - arch/
  - package.
  - output/
  - ...

buildroot 可以方便的构建满足不同目标的镜像，通常使用 O 指定不同目录来保存针对不同目标的输出文件，例如：

- project/
  - buildroot
  - foo-output/
    - .config
  - bar-output/
    - .config

有两种方式使用 to start an out of tree build.

- From the top-level Buildroot source directory
`make O=../foo-output/ menuconfig`
- From an empty output directory
`make -C ../buildroot/ O=$(pwd) menuconfig` 其中 `-C` 指定 `makefile` 所在的目录。

运行上述命令后， buildroot 会在 O 配置的目录中生成一个起包裹作用的 Makefile，后续的构建过程无需再次指定输出目录。

# 配置文件分析

Buildroot 有多种配置文件，初次使用时不易清晰分辨。$(TOP_DIR) 下的 .config 包含了所有的配置选项，.config 为自动生成，不要手动去修改。defconfig 保存了非默认的选项，易于阅读和修改，通常有厂家给出。

通常的开发流程为：
- 基于厂家给出的 defconfig 开发，在 `buildroot/configs`目录
- 开发的过程中会保存阶段性成果的配置，使用`make savedefconfig`, 保存位置由选项 `BR2_DEFCONFIG` 指定。
- `make list-defconfigs` 列出所有的 defconfig files，即列出`buildroot/configs`下的所有文件。

组合多个 fragments，生成 defconfig 文件：
- buildroot/support/kconfig/merge_config.sh  platform1.frag packages.frag > .configs
- make olddefconfig

`make olddefconfig` 的作用是将默认的配置添加到 .config 文件(expands a minimal defconfig to a full .config)。

# buildroot 目录树

## 源码树

- Makefile
- Config.in （top-level Config.in, Includes many other Config.in files）
- arch/
- toolchain/
- system/
  - skeleton/ (the rootfs skeleton, 构建开始时复制到 `$(TARGET_DIR)`)
  - Config.in
- linux/
  - linux.mk
- package/
  - user space packages
  - busybox/, gcc/, qt5/, etc
  - pkg-generic.mk, core package infrastructure
  - pkg-cmake.mk, pkg-autotools.mk, pkg-perl.mk, etc. **Specialized package infrastructure.**
- fs/
  - common.mk
  - cpio/, ext2/, squashfs/, tar/, ubifs/, etc 文件系统的打包方式。
- boot/
- configs/
- board/
- suport/
- utils/
- docs/

## 构建树

- output/  (BASE_DIR)
  - build/
    = Where all source tarballs are extracted
    - Where the build of each package takes place
    - stamp files are created by buildroot
    - **Variable: BUILD_DIR**
  - host/
    - Variable: HOST_DIR
    - Variable for the sysroot: STAGING_DIR
  - staging
  - target/
    - Variable: TARGET_DIR
  - images/
    - Variable: BINARIES_DIR
  - graphs/
    - make graph-depends
    - make graph-size
    - make graph-build
    - Variable: GRAPHS_DIR
  - legal-info/
    - make legal-info
    - Variable: LEGAL_INFO_DIR
