---
title: Container Adaptors
date: 2016-07-13 13:53:04
tags:
  - 写给自己看的教程
  - cpp
  - key concepts
---

The library defines three sequential container Adaptors: `stack`, `queue`, and `priority_queue`. Essentially, an adaptor is a mechanism for making one thing act like another. **A container adaptor takes an existing container type and makes it act like a different type**.

## Defining an Adaptor

Each adaptor defines two constructors: the dafault constructor that creates an empty object, and a constructor that takes a Container and initializes the adaptor by copying the given container.

Both `stack` and `queue` are implemented in terms of `deqeue`, and a `priority_queue` is implemented on a `vector`.
