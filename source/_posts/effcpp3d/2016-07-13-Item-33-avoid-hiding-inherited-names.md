---
title: 『Effective C++ 读书笔记33』 避免遮掩继承而来的名称
date: 2016-07-13 09:03:06
tags:
  - cpp
---
这个题材和继承其实无关，而是和作用域有关。我们都知道在诸如这般的代码中：
```cpp
int x;
void someFunc()
{
  double x;
  std::cin >> x;
}
```
这条读取数据的语句指涉的是 local 变量 x,而不是 global 变量 x，因为内存作用域的名字会掩盖外层作用域的名称。

<!-- more -->
我们知道，当位于一个 derived class 成员函数内指涉 base class 内的某物时，编译器可以找出我们所指涉的东西，因为 derived calss 继承了声明于 base classes 内的所有东西。实际的运作方式是，derived class 作用域被嵌套在 base class 作用域内。


```cpp
class Base{
private:
  int x;
public:
  virtual void mf1() = 0;
  virtual void mf2();
  void mf3();
  ...
};

class Derived: public Base{
public:
  virtual void mf1();
  void mf4();
  ...
};
```
假设 derived class 内的 mf4 的实现码部分像这样：
```cpp
void Derived::mf4()
{
  ...
  mf2();
  ...
}
```
当编译器看到这里使用名称 mf2， 必须估算它所指涉什么东西。 **编译器的做法是查找各作用域，看看有没有某个名为 mf2 的声明式**。 local --> class derived --> base class -->  namespace -->  global。

```cpp
class Base{
private:
  int x;
public:
  virtual void mf1() = 0;
  virtual void mf1(int);
  virtual void mf2();
  void mf3();
  void mf3(double);
  ...
};

class Derived: public Base{
public:
  virtual void mf1();
  void mf3();
  void mf4();
  ...
};
```
分析下列代码调用的是基类还是子类的函数

```cpp
Derived d;
int x;
...
d.mf1();                          //ok
d.mf1(x);                         //err
d.mf2();
d.mf3();
d.mf3(3);                         //err
```

public 继承必须满足 is-a 的关系，使用 using 使基类的所有内容咋派生类中可见

```cpp
class Base{
private:
  int x;
public:
  virtual void mf1() = 0;
  virtual void mf1(int);
  virtual void mf2();
  void mf3();
  void mf3(double);
  ...
};

class Derived: public Base{
public:
  using Base::mf1;
  using Base::mf3;
  virtual void mf1();
  void mf3();
  void mf4();
  ...
};
这意味着如果你继承 base class 并加上重载函数，而你又希望重新定义或覆写其中一部分，那么你必须为哪些原本会被遮掩的每个名称引入一个 using 声明式，否则某些你希望继承的名称会被遮掩。

如果不想继承 base class 所有的函数，但这在 public 继承下是不可能的。我们可以使用转交函数来满足要求。
```cpp
class Base{
public:
  virtual void mf1() =0;
  virtual void mf1(int);
  ...
};
class Derived: private Base{
public:
  virtual void mf1()
  {
    Base::mf1();
  }
  ...
};
...
Derived d;
int x;
d.mf1():                                      // ok
d.mf1(x);                                     //err
```


---

- ` derived class` 内的名称会掩盖 `base classes` 内的名称。在 `public` 继承下从来没有人希望如此
- 为了让掩盖的名称再见天日，可使用 `using` 声明式或转交函数（ `forwarding functions` ）
