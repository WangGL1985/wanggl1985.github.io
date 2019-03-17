---
title: 『Effective C++ 读书笔记32』 确定你的 public 继承塑模出 is-a 关系
date: 2016-07-12 08:42:40
tags:
  - cpp
---


『继承』可以是单一继承或多重继承，每一个继承连接可以是 `public`， `protected`或 `private`，也可以是虚或非虚。成员函数选项：『虚』、『非虚』、『纯虚』、以及成员函数和其他语言特性的交互影响；缺省参数值与虚函数有什么交互影响？继承如何影响 `C++` 的名称查找规则？设计选项有哪些？如果 `class` 的行为需要修改， `virtual`函数是最佳选择吗？

<!-- more -->
**『公开继承』 `public inheritance` 意味 `is-a` 的关系。切记！**

---

**public** 继承意味着 `is-a`。适用于 `base classes` 身上的每一件事情一定也适用于 `derived classes` 身上，因为每一个 `derived class` 对象也都是一个 `base class` 对象。
