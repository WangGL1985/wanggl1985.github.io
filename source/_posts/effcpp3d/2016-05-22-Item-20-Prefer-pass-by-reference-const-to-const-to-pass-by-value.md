---
layout: post
title: 『Effective C++ 读书笔记20』 宁以 pass-by-reference-to-const 替换 pass-by-value
date: 2016-05-20
tags:
  - cpp
---

缺省情况下 C++ 以 by value 方式传递对象至函数，即形参以实参的一个副本为初值。

<!-- more -->
