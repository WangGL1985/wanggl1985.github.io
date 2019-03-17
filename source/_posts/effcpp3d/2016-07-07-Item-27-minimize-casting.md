---
title: 『Effective C++ 读书笔记27』 尽量少做转型动作
date: 2016-07-07 10:36:51
tags:
  - cpp
---

C++ 规则的设计目标之一是，保证『类型错误』绝不可能发生，转型破坏了类型系统， `C++` 转型可能导致任何种类的麻烦。

<!-- more -->
`C` 风格的转型动作 `(T)expression` or `T(expression)`,称为旧式转型。 `C++`提供四种新式转型：

- `const_cast<T>( expression )`
- `dynamic_cast<T>( expression )`
- `reinterpret_cast<T>( expression )`
- `static_cast<T>( expression )`

各有不同的目的

- `const_cast` 将对象的常量性转除
- `dynamic_cast` 执行『安全向下转型』，决定某对象是否归属继承体系中的某个类型。
- `reinterpret_cast` 执行低级转型，实际动作取决于编译器，不可移植
- `static_cast` 用来强迫隐式转换，将 `non-const` to `const`, `int` to `double`

新式转型较旧式转型有以下优点：

- 很容易在代码中被辨识出来，简化类型系统 debug 过程
- 各转型动作的目标愈窄化，编译器俞可能诊断出错误的运用

当要调用一个 explicit 构造函数将一个对象传递给一个函数时。
```cpp
class Widget{
public:
  explicit Widget( int size);
  ...
};
void doSomeWork(const Widget& w);
doSomeWork(Widget(15));                         //以一个 int 加上『函数风格』的转型动作创建一个 widget

doSomeWork(static_cast<Widget>(15));            //以一个 int 加上『C++风格』的转型动作创建一个 widget

```

任何一种转型往往真的令编译器编译出运行期间执行的码。

```cpp
class Base{...}
class Derived: public Base {...};
Derived d;
Base* pb=&d;
```

有上述代码分析可知，单一对象可能拥有一个以上的地址。意味着『知道对象如何布局』而设计的转型，往往是平台相依的。

我们很容易写出某些似是而非的代码：
```cpp
class window{
public:
  virtual void onResize() {...}
  ...
};
class SpecialWindow: public Window{
public:
  virtual void onResize(){
    static_cast<Window>(*this).onResize();
    ...
  }
  ...
};
```
在当前对象的基类成分的副本上调用 window::onResize，然后...

解决方法是拿掉转型
```cpp
class SpecialWindow: public Window{
public:
  virtual void onResize(){
    Window::onResize();
    ...
  }
  ...
};

```

使用 `dynamic_cast` 通常是因为你想在一个你认为 `derived class` 对象身上执行 `derived class` 操作函数，但你只有一个指向 `base` 的 `pointer` 或 `reference`。

解决方法有两：

- 使用容器存贮直接指向 `derived class` 对象的指针

```cpp
class Window{...};
class SpecialWindow: public Window{
public:
  void blink();
  ...
};
typedef std::vector<std::tr1::shared_ptr<Window> v;
v winPtr;
...
for (v::iterator  iter = winPtr.begin(); iter != winPtr.end(); iter++) {
  if (SpecialWindow *psw = dynamic_cast<SpecialWindow*>(iter->get())) {
    psw->blink();
  }
}
```
应该改为这样做
```cpp
typedef std::vector<std::tr1::shared_ptr<SpecialWindow> > VPSW;
VPSW winPtrs;
...
for (VPSW::iterator iter  = winPtrs.begin(); iter != winPtrs.end(); ++iter ) {
  (*iter)->blink();
}
```
- 通过基类接口处理『指向所有可能之各种 Window 派生类』，就是在 `base class` 内提供 `virtual` 函数做你想对各个 `Window` 派生类做的事。
```cpp
class Window{
public:
  virtual void blink(){}
  ...
};
class SpecialWindow: public Window{
public:
  virtual void blink(){ ... };
  ...
};
typedef std::vector<std::tr1::shared_ptr<SpecialWindow> > VPW;
VPSW winPtrs;
...
for (VPSW::iterator iter  = winPtrs.begin(); iter != winPtrs.end(); ++iter ) {
  (*iter)->blink();
}
```

上述方法归结为『使用类型安全容器』或『将 `virrual` 向继承体系上方移动』。

---

- 如果可以，尽量避免转型，特别是在注重效率的代码中避免 `dynamic_cast`
- 如果转型是必须的，试着将它隐藏于某个函数背后。客户随后可以调用该函数，而不需将转型放进它们自己的代码内
- 使用新式转型
