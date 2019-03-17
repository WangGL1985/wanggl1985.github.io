---
layout: post
title: 『Effective C++ 读书笔记16』 成对使用 new 和 delete 时要采用相同形式
date: 2016-05-12
tags:
  -  cpp
---

分析代码：

```cpp
std::string* stringArray = new std::string[100];
...
delete stringArray;
```
<!-- more -->
当使用 `new` 时有两件事发生：

-	内存被分配出来
-	针对此内存会有一个（或更多）构造函数被调用

当使用`delete`，也有两件事发生

-	针对内存会有一个（或多个）析构函数被调用
-	内存被释放

`delete` 的问题是，即将被删除的内存之内究竟有多少对象？这个问题的答案决定了有多少个析构函数必须被调用。<font color="red" size=4> 通常，数组所用的内存通常还包括 『数组大小』的记录，单一对象的内存则没有这笔记录。</font>

**当你对一个指针使用 delete，唯一能够让 delete 知道内存中是否存在一个『数据大小记录』的办法就是：由你来告诉它**。当使用 delete 时加上中括号，delete 便认为指针指向一个数组，否则它便认定指针指向单一对象。

```cpp
std::string* stringPtr1 = new std::string;
std::string* stringPtr2 = new std::string[100];
...
delete stringPtr1;
delete [] stringPtr2;
```

---

-  如果你在 `new` 表达式中使用 `[]`，必须在相应的 `delete` 表达式中也使用 `[]`. 如果你在 `new` 表达式中不使用 `[]`,一定不要在相应的 `delete` 表达式中使用 `[]`.
