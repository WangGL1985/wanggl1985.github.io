---
layout: post
title: 『Effective C++ 读书笔记10』 令 operator= 返回一个 reference to *this
date: 2016-05-03
tags:
	- cpp
---

赋值采用向右结合律，为了实现『连锁赋值』，赋值操作符必须返回一个 `reference` 指向操作符的左侧实参。 class 实现赋值操作符时应该遵循的协议：
<!-- more -->
```cpp
class Widget{
public:
	...
	Widget& operator=(const Widget& rhs)
	{
		...
		return *this;
	}
	...
};
```

除了标准的赋值形式，所有的赋值形式 (`+=,-=,*=`) 都必须遵循这个标准。

```cpp
class Widget{
public:
	...
	Widget& operator+=(const Widget& rhs)
	{
		...
		return *this;
	}
	Widget& operator=(int rhs)						//此函数也适用，即使此一操作符的参数类型不符合协定
	{
		...
		return *this;
	}
};
```
这个协议并无强制性，好处是可以和内置类型和标准程序库提供的类型如 sring、vector、complex、tr1::Shared_ptr 或即将提供的类型共同遵守。

---

-	令赋值操作符返回一个 `reference to *this`
