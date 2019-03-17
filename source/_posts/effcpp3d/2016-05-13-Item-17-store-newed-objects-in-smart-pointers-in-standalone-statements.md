---
layout: post
title: 『Effective C++ 读书笔记17』 以独立语句将 newd 对象置入智能指针
date: 2016-05-13
tags:
  - cpp
---

假设有一个函数揭示处理程序的优先权，另一个函数用来在某动态分配所得的 `widget` 上进行某些带有优先权的处理：


```cpp
int priority();
void processWidget(std::tr1::shared_ptr<Widget> pw, int priority);
```
<!-- more -->
以语句 `processWidget(new Widget, priority());` 调用函数，`tr1::shared_ptr` 构造函数需要一个原始指针，但构造函数是一个 `explicit` 构造函数，无法进行隐式转换。

```cpp
processWidget(std::tr1::shared_ptr<Widget>(new Widget), priority());
```
虽然使用了智能指针，但是仍然有可能造成内存泄露。因为  `std::tr1::shared_ptr<Widget>(new Widget)` 由两部分组成：

-	执行 `new Widget`
-	调用 `tr1::shared_ptr` 构造函数

在调用 `processWidget` 之前，编译器必须执行以下三部：

-	调用`priority`
-	执行 `new Widget`
-	调用 `tr1::shared_ptr` 构造函数

但 `C++` 不能确定这三者的执行顺序，如果在调用 priority 时出现异常，解决方案就是分离语句：

```cpp
std::tr1::shared_ptr<Widget> pw(new Widget);                  //在单独语句内智能指针存储 newed 对象
processWidget(pw, priority());
```

---

-  以独立语句将 `newd` 对象存储于智能指针内，如果不这样做，一旦异常被抛出，有可能导致难以察觉的资源泄露。
