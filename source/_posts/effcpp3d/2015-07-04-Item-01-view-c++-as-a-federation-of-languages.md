---
layout: post
title: 『Effective C++ 读书笔记1』 视 C++ 为一个语言联邦
date: 2016-07-04
tags:
    - cpp
---


C++ is a powerful language with an enormous range of features, but before you can harness that power and make effective use of those features, you have to accustom youself to C++'s way of doing things.

<!--more-->
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-04-18-154424.jpg)

现今 `c++` 已经是一个多重泛型编程语言(multiparadigm programming language)，**同时支持过程形式（procedural）、面向对象形式（Object-oriented）、 函数形式（function）、泛型形式（generic）、元编程形式的语言（metaprogramming）**。 如何去理解一个如此复杂的语言呢，最简单的做法是将 `C++` 视为一个由相关语言组成的联邦语言。在其某个『次语言』中，各种守则和通则都比较简单，直观易懂，容易记住。然而当你从转向另一个『次语言』时，守则可能改变。为了理解 C++ ，首先必须认识主要的次语言。


#  C

`C++` 仍以 `C` 为基础，**区块(block)、语言(language)、预处理(preprocessor)、内置类型(built-in data type)、数组(array)、指针(pointer)**等都来自 `C`。但当你以 `C++` 内的 `C` 成分工作时，高效编程守则将映射出 `C` 的不足： 没有模板、没有异常、没有重载...

# **Object-Oriented C++**

即所谓的 `C with Class`，关键概念包括:

-   classes
-   encapsulation
-   inheritance
-   polymorphism
-   virtual function (dynamic binding)
-   ...

# **Template C++**


模板代表的是泛型编程部分，引申出模板元编程

# **STL**

是一个模板程序库，包括容器，迭代器，算法以及函数对象等。

当你从不同『次语言』之间切换时，就会引发编程策略的改变。 `C++` 并不是一个带有一组守则的一体语言；是一个联邦语言，每个『次语言』都有自己的规定。

> C++ 高效编程守则视状况而变化，取决于你使用 C++ 的那一部分。

定义你想怎么样使用 C++ 非常重要，这决定了你的项目是否能够一直做下去直到发布。就算只有你一个人做项目，你也会使用别人的代码，或提供扩展接口供别人编写扩展。这都会和并非出自你手的代码打交道。即使所有的一切都是由你一个人掌握，你也不可能随心所欲地使用哪些 C++ 中看起来最酷的特性，因为你总会发现 C++ 中还有更有趣的东西可供挖掘。这种想法很危险，因为如此一来项目会逐渐偏离原始的目标，编写 C++ 代码只是为了用 C++ 编写，而非为了解决问题。 --引自 **云风**
