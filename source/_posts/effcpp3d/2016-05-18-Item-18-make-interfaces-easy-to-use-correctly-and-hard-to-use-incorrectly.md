---
layout: post
title: Effective C++ 读书笔记18』 让接口容易被正确使用，不易被误用
date: 2016-05-15
tags:
	- cpp
---


`C++` 中有各种各样的接口: `function` 接口、 `class` 接口、 `template` 接口..., 要开发一个「容易被正确使用，不容易被误用」的接口，首先要考虑客户可能做出什么样的错误。设计一个表现日期的类,构造函数如下：

```cpp

class Date{
public:
	Date(int month, int day, int year);
	...
};
```

客户有可能犯一下错误：

-	错误的顺序传递参数
-	传递一个无效的参数

许多客户端错误可以因为导入新类型而获得预防。
```cpp
struct Month{
	explicit Month(int m)
	:val(m){}
	int val;
};

```
限制类型内什么事可做，什么事不能做。常见的是加上 const。例如，『以 const 修饰 operator* 的返回类型』可阻止客户因用户自定义类型而犯错。

实现工厂函数，直接返回智能指针对象
```cpp
std::tr1::shared_ptr<Investment> createInvestment()
{
	std::tr1::shared_ptr<Investment> retVal(static_cast<Investment* >(0), getRidOfInvestment);
	retVal = ...;
	return retVal;
}

```
---

-	好的接口很容易被正确使用，不容易被误用。你应该在你的所有接口中努力达成这些性质
-	『促进正确使用』的办法包括接口一致性，以及与内置类型的行为兼容
-	『阻止使用』的办法包括建立新类型、限制类型上的操作，束缚对象值，以及消除客户的资源管理责任
-	`tr1::shared_ptr` 支持定制型删除器，这可防范 `DLL` 问题，可被用来自动接触互斥锁。
