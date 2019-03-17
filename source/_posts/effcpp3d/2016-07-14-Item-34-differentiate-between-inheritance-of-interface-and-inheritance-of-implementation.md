---
title: 『Effective C++ 读书笔记34』 区分接口继承和实现继承
date: 2016-07-14 09:26:13
tags:
  - cpp
---
`public` 继承有两部分组成，函数接口继承和函数实现继承，身为 class 设计者
- 有时候你希望 derived classes 只继承成员函数的接口；
- 有时候你又希望 derived classes 同时继承函数的接口和实现，但又希望能够覆写它们所继承的实现
- 有时候你希望 derived classes 同时继承函数的接口和实现，并且不允许覆写任何东西


<!-- more -->

```cpp
class Shape{
public:
  virtual void draw() const = 0;
  virtual void error(const std::string& msg);
  int objectID() const;
  ...
};
class Rectangle: public Shape {...};
class Ellipse: public Shape { ... };
```

Shape 是一个抽象 class，影响所有以 public 形式继承它的 derived classes。

- 成员函数的接口总是会被继承
- 声明一个 `pure virtual` 函数的目的是为了让 `derived classes` 只继承函数接口
  - 因为纯虚函数在抽象类中没有定义
  - 派生类必须重新声明
- 可以在抽象类中为 `pure virtual` 函数提供定义，调用时提供类名称
```cpp
Shape* ps = new Shape;
Shape* ps1 = new Rectangle;
ps1->draw();
Shape* ps2 = new Ellipse;
ps2->draw();
ps1->Shape::draw();
ps2->Shape::draw();

```

- 声明 `impure virtual` 函数的目的， 是让 `derived classes` 继承该函数的**接口和缺省实现**
  - 纯虚函数必须在派生类中重新声明，但它们也可以拥有自己的实现
- 声明非虚函数的目的是为了令派生类继承函数的接口及一份强制性实现

---

- 接口继承和实现继承不同。在 `public` 继承之下， `derived classes` 总是继承 `base class` 的接口
- `pure virtual` 函数只具体指定接口继承
- 虚函数具体指定接口继承及缺省实现继承
- 非虚函数具体指定接口继承以及强制性实现继承
