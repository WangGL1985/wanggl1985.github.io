---
title: 『Effective C++ 读书笔记44』 将与参数无关的代码抽离 templates
date: 2016-07-22 10:01:16
tags:
  - cpp
---


<!-- more -->
- `Templates` 生成多个 `classes` 和多个参数，所以任何 `template` 代码都不该与某个造成膨胀的 `template` 参数产生相依关系
- 因非类型模板参数造成的代码膨胀，往往可以消除，做法是以函数参数或从 `class` 成员变量替换 `template` 参数
- 因类型参数而造成的代码膨胀，往往可降低，做法是让带有完全相同二进制表述的具现类型共享实现码。
