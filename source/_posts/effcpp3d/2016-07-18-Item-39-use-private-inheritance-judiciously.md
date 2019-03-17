---
title: 『Effective C++ 读书笔记39』 明智而审慎地使用 private 继承
date: 2016-07-18 11:46:15
tags:
  - cpp
---

```cpp
class Person { .... };
class Student: private Person { ... };
void eat(const Person& p);
void study(const Student& s);

Person p;
Student s;

eat(p);
eat(s);  //bad
```
如果 `classes` 之间的继承关系是 `private`，编译器不会自动将一个 `derived class` 对象转换为一个 `base class` 对象。私有继承而来的基类的所有成员，在派生类中都会变成 `private` 属性。私有继承意味着 `implemented-in-terms-of`。如果以 `class D` 以 `private` 形式继承 `class B`，你的用意是为了采用 `class B` 内已经备妥的某些特性，不是因为 `B` 对象和 `D` 对象存在有任何观念上的关系。

`private` 继承纯粹只是一种实现技术『这就是为什么继承自一个 `private base class` 的每样东西在你的 `class` 内都是 `private`；因为他们都只是实现枝节而已 』。 `private` 继承意味只有实现部分被继承，接口应略去。`private` 继承在软件『设计』层面上没有意义，其意义只及于软件实现层面。

复合和私有继承都是『根据某物实现出』，那么该如何取舍呢？ **尽可能使用复合，当 protected 成员和虚函数被牵扯进来时，才使用私有继承**。分析代码
```cpp
class Widget: private Timer{
private:
  virtual void onTick() const;
};
```
这种实现并不一定好，如果想要阻止 Widget 的继承类重新定义 onTick，怎么实现呢？

```cpp
class Widget{
private:
  class WidgetTimer: public Timer{
  public:
    virtual void onTick() const;
    ...
  };
  WidgetTimer timer;
};
```
上述设计的优点是：1、 可以阻止派生类重新定义 onTick；2、将 Widget 的编译依存性降至最低。

---

- `Private` 继承意味着...。通常比符合的级别低，当派生类需要访问 `protected base class` 的成员，或需要重新定义继承而来的 `virtual` 函数时，这么设计是合理的。
- `private` 继承可以造成 `empty base` 最优化。 有利于『对象尺寸最小化』
