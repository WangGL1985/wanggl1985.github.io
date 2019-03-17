---
layout: post
title: 『Effective C++ 读书笔记7』为多态基类声明 virtual 析构函数（Declare destruction virtual in polymorphic base classes）
date: 2016-04-29
tags:
	-	cpp
---

设计一个 `TimeKeeper base class` 和一些 `derived classes` 作为不同的计时方法：

<!-- more -->
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-04-19-143742.jpg)
```cpp
class TimeKeeper{
public:
	TimeKeeper();
	~TimeKeeper();
	...
};

class AtomicClock: public TimeKeeper{ ... };
class WaterClock: public TimeKeeper{ ... };
class WristWatch: public TimeKeeper{ ... };
```

设计一个 `factory` 函数，返回指针指向一个计时对象.

>`Factory` 函数会『返回一个 `base class` 指针』，指向新生成之 `derived class` 对象。

```cpp
TimeKeeper* getTimeKeeper();
```

遵守 `factory` 函数的规则，被 `getTimeKeeper()` 返回的对象必须在 `heap`。因此为了避免泄露内存和其他资源，将 `factory` 函数返回的每一个对象适当地 `delete` 掉：

```cpp
TimeKeeper* ptr = getTimeKeeper();
...
delete ptk;
```

`getTimeKeeper` 返回的指针指向一个 `derived class` 对象，而那个对象却经由一个 `base class` 指针被删除，而目前的 `base class` 有个 `non-virtual` 析构函数。**`C++` 明确指出，当 `derived class` 对象经由一个 `base class` 指针被删除，而该 `base class` 带着一个 `non-virtual` 析构函数，其结果是未定义的。**。通常执行的结果是 `derived` 成分没有被销毁,造成『局部销毁』现象。

```cpp
class TimeKeeper{
public:
	TimeKeeper();
	virtual ~TimeKeeper();
	...
};
TimeKeeper* ptr = getTimeKeeper();
...
delete ptr;
```


`base class` 的 `virtual` 析构函数，此后删除 `derived class` 对象就会如你想要的，它会销毁整个对象，包括所有 `derived class` 成分。但是不要为不作为基类的类添加虚析构，因为这样会增大对象的体积。以一个表示 2D point 的类为例

```cpp
class Point
{
public:
	Point(int a, int b);
	~Point();

private:
	int x;
	int y;
}
```
如果 int 占 32 bits，则整个 Point 对象将占用 64 bits 的空间。当存在虚函数时， Point 对象必须为虚函数表分配存储空间。 **当 class 内含有至少一个 virtual 函数时， 将析构声明为 virtual**


如果将一个含有非虚析构的类作为基类，给希望成为抽象类的类声明一个 `pure virtual` 析构函数。

```cpp
//In the header file
class AWOV{
public:
	virtual ~AWOV() = 0;
};
```

编译器会在每一个继承类的析构函数中创建一个对 `~AWOV()` 的调用动作，所以你必须为这个函数提供一份定义。

```cpp
//In the source file
AMOV()::~AWOV() {}
```
如果 class 不含有虚函数，通常表示它并不意图被用做一个基类。当类不企图被当做基类，却有一个虚析构函数，通常不是一个好主意。因为当含有虚函数时，对象的体积就会增大。**给基类一个虚析构函数，这个规则只适用于带有多态机制的基类身上（至少有一个 virtual 函数），这种基类的设计目的就是为了通过基类接口处理派生类对象。并非所有的基类的设计目的是为了多态用途,如 item06 的 Uncopyable 类。**

---

-	`polymorphic base classes` 应该声明一个 `virtual` 析构函数。如果 `class` 带有任何虚函数，它就应该拥有一个虚析构函数。
-	`classes` 如果不是作为基类使用，或不是为了具备多态性，就不该声明 `virtual` 析构函数。
