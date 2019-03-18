---
title: buildroot 学习/实践记录(三) -- buildroot 中的工具链
tags:
  - Buildroot
  - linux
---


什么是交叉编译工具链(cross-compilation toolchain)。

> A set of tools to build and debug code for a target architecture, from a machine running a different architecture.

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-12-29-100755.jpg)

Buildroot offers two choices for the toolchain, called **toolchain backends**:
- The **internal toolchain** backend, where Buildroot builds the toolchain entirely from source.
  - Makes Buildroot build the entire cross-compilation toolchain from source.
  - Provides a lot of flexibility in the configuration of the toochain.
    - Kernel headers versions
    - C library: Buildroot supports uClibc, glibc and modules_install
    - Different versions of binutils and gcc.
    - Numerous toolchain options: C++, LTO, OpenMP, libmudflap, graphite
  - results
    - host/bin/
    - host/
      - sysroot/usr/include
      - sysroot/lib
      - sysroot/usr/lib
      - /include/c++/
      - lib/
    - target/
      - lib
      - usr/lib

- The **external toolchain** backend, where Buildroot uses a exiting pre-built toolchain.
  - Allows to re-use existing pre-built toolchains
  - Several options:
    - Use an existing toolchain profile known by Bulidroot
    - Download and install a custom external toolchian
    - Directly use a pre-installed custom external toolchains
  - Buildroot alwready knows about a wide selection of publicly available toolchains.
  - Toolchains from Linaro, Mentor Graphics, Imagination Technologies
- Custom external toolchains
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-12-30-234548.jpg)
- External toolchain: result
- It is therefore important to use kernel headers that have a version equal or older than the kernel version running on the target.
