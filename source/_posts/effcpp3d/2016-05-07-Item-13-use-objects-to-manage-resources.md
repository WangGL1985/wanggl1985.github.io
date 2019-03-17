---
layout: post
title: 『Effective C++ 读书笔记13』 以对象管理资源(Use objects to manage resources)
date: 2016-05-07
tags:
	- cpp
---

什么是资源？**所谓资源就是，一旦用了它，将来必须还给系统**。 `c++` 中最常见的资源就是动态分配的内存，其他资源有『文件描述器』、『互斥锁』、图形界面中的字型和笔刷、数据库连接、以及网络 `sockets`。

<!-- more -->

以一个塑模投资行为的程序库来做分析，各种投资类型继承自 `Investment`。

```cpp
class Investment{ ... };
```

利用工厂函数供应某特定的 `Investment` 对象

```cpp
Investment* createInvestment();									//返回指针，指向 Investment 继承体系内的动态分配对象。调用者必须删除之
```

`createInvestment` 的调用端使用了函数返回的对象后，必须删除之。

```cpp
void f()
{
	Investment* pink = createInvestment();
	...
	delete pink;
}
```

看起来似乎没有问题，但是在 `...` 区域内可能因为 `return` 语句，或是循环中的`continue` 或 `goto` 使函数不能执行到 `delete` 语句。则会导致内存泄露。

为了确保 `createInvestment` 返回的资源总是被释放，我们需要**将资源放进对象内**，当控制流离开 `f`，该对象的析构函数会自动释放那些资源。许多资源被动态分配于 `heap` 内后被用于单一区块或函数内。它们应该在控制流离开那个区块或函数时被释放。标准程序库提供的 `auto_ptr` 正是针对这种形势而设计的特制产品。 `auto_ptr` 是个『类指针对象』，其析构函数自动对其所指对象调用 `delete`。

```cpp
void f()
{
	std::auto_ptr<Investment> pInv(createInvestment());
	...
}
```
『以对象管理资源』的两个关键想法：

-	获得资源后立即放进管理对象内，获取的对象作为对象的初始化值。即『资源取得时机便是初始化时机』(resource acquisition is initialization, RAII)
-	管理对象运用析构函数确保资源被释放,不论控制流如何离开区块，一旦对象被销毁，其析构函数自然会被自动调用，于是资源被释放。

由于 `auto_ptr` 被销毁时会自动删除它所指之物，所以一定要注意别让多个 `auto_ptr` 同时指向同一个对象。 **`auto_ptrs` 有一个不寻常的性质；若通过 `copying` 复制它们，它们就会变为 `null`， 而复制所得的指针将取得资源的唯一拥有权**。

```cpp
std::auto_ptr<Investment>	pInv1(createInvestment())；   //pInv指向createInvestment返回物
std::auto_ptr<Investment> pInv2(pInv1);	               //现在pInv2指向对象，pInv1被设为null
pInv1 = pInv2;                                         //现在pInv1指向对象，pInv2被设为null
```
```cpp
#include <iostream>

class Investment{};

Investment* createInvestment()
{
    Investment* pInv = new Investment();
    return pInv;
}

int main()
{
    std::auto_ptr<Investment> pInv(createInvestment());
    return 0;
}
```
这一诡异的复制行为，复加上其底层条件：『受`auto_ptr`管理的资源必须绝对没有一个以上的`auot_ptr`同时指向它』。<font color="red">但是 `STL` 容器要求其元素发挥正常的『复制行为』，因此这些容器不能使用`auto_ptr`。</font>

`auto_ptr` 的替代方案是 **reference-counting smart pointer;RCSP**『引用计数型智能指针』。其持续追踪共有多少对象指向某笔资源，并在无人指向它时自动删除该资源。`RCSPs` 提供的行为类似垃圾回收，但是 `RCSPs` 无法打破环状引用。

`TR1` 的 `tr1::shared_ptr` 就是个 `RCSP`，所以可以下面的代码：

```cpp
void f()
{
	...
	std::tr1::shared_ptr<Investment> pInv(createInvestment());
	...
}
```

`shared_ptrs` 的复制行为

```cpp
void f()
{
	...
	std::tr1::shared_ptr<Investment>
	pInv1(createInvestment());

	std::tr1::shared_ptr<Investment>
	pInv2(pInv1);
	pInv1 = pInv2;
	...
}
```
`auto_ptr` 和 `shared_ptr` 在析构函数内做的是 `delete` 动作，而不是 `delete []` 动作。

---

-	为防止资源泄露，请使用 `RAII` 对象，它们在构造函数中获得资源并在析构函数中释放资源
-	两个常被使用的 `RAII classes` 分别是 `tr1::shared_ptr` 和 `auto_ptr`。
