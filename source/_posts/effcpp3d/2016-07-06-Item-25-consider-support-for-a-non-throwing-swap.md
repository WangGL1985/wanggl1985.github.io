---
title: 『Effective C++ 读书笔记25』考虑写出一个不抛出异常的 swap 函数
date: 2016-07-08 09:05:49
tags:
  - cpp
---

`swap` 是异常安全性编程的脊柱，同时也是处理自我赋值可能性的常见机制.`swap` 是指将两对象的值赋予对方,缺省情况下可以由 `STL` 提供的 `swap` 算法完成。

<!-- more -->

典型实现如下：
```cpp
namespace std {
  template<typename T>
  void swap(T& a, T& b) {
    T temp(a);
    a = b;
    b = temp;
  }
}
```
只要类型 `T` 支持 `copying`，缺省的 `swap` 实现代码就会帮你置换类型为 `T` 的对象。但是对某些类型而言，这些复制动作无一必要；其中最主要的就是『以指针指向一个对象，内含真正数据』那种类型，即所谓『pimpl 手法』。如果是置换 `pimpl`， 则是『化简为繁』了。分析代码

```cpp
class WidgetImpl{
  public:
  ...
private:
  int a, b, c;
  std::std::vector<double> v;
  ...
}；

class Widget {
public:
  Widget(const Widget& rhs);
  Widget& operator=(const Widget& rhs)
  {
    ...
    *pImpl = *(rhs.pImpl);
    ...
  }
  ...
private:
  WidgetImpl* pImpl;
};
```
如何置换两个 widget 对象值，我们唯一需要做的就是置换其 pImpl 指针，但缺省的`swap`算法不知道这一点 。我们希望能够告诉 std::swap，当进行 `Widgets`的置换时，只是置换其内部的 `pImpl` 指针。

```cpp
namespace std{
  template<>                                      //std::swap 针对 『T 是 widget』的特化版本
  void swap<Widget>(Widget& a, Widget&b) {        //目前不能通过编译
    swap(a.pImpl,b.pImpl);                        //只需置换指针
  }
}
```

- `template<>` 表示是 `std::swap` 的一个全特化版本
- `<Widget>` 表示这个特化版本系针对『T是Widget』而设计

当一般性的 swap template 施行于 widgets 身上便会启用这个版本。通常不允许改变 `std` 命名空间内的任何东西，但可以为标准 `template` 制造特化版本，使他专属于我们自己的 `classes`。

但是，上述函数不能通过编译。

- 可以将特化版本声明为 `friend`，但不是一个好方法
- 写一个正真的 `public` 的 `swap` 函数，令 `std::swap` 特化，令它调用该成员函数

```cpp
class Widget {
private:
  ...
public:
  Widget (arguments);
  virtual ~Widget ();

  void swap(Widget& other) {
    using std::swap;
    swap(pImpl,other.pImpl);
  }
  ...
};
namespace std {
  template<>
  void swap<Widget>(Widget& a, Widget& b) {
    a.swap(b);                                        //若置换 widgets，调用其 swap 成员函数
  }
};
```
这种做法可以很好的和 STL 容器有一致性，因为所有 STL 容器也都提供有 public swap 成员函数和 std::swap 特化版本。


然而假设 widget 和 widgetImpl 都是 class templates 而非 classes，可以试试将 widgetImpl 内的数据类型加以参数化：
```cpp
template<typename T>
class WidgetImpl { ... };

template <typename T>
class Widget { ... };
```
在 widget 内放一个 swap 成员函数
```cpp
namespace std{
  template<typename T>
  void swap<Widget<T> > (widget<T>& a, widget<T>& b)
  {
    a.swap(b);
  }
}
```

我们企图偏特化一个 function template，但 C++ 只允许对 class templates 偏特化，在 function templates 身上偏特化行不通。替代方案是为它添加一个重载版本：

```cpp
namespace std {
  template<typename T>
  void swap(T& a, T& b) {
    T temp(a);
    a = b;
    b = temp;ß
  }
}
```

```cpp
namespace std{
  template<typename T>
  void swap(Widget<T>& a, Widget<T>& b)
  {
    a.swap(b);
  }
}
```
---

- 如果 `swap` 缺省实现版的效率不足（一般都是因为 `class` 或 `template` 使用了某种 `pimpl` 手法），提供一个 `public swap` 成员函数，高效地置换你的类型的两个对象值，并确定这个函数不抛出异常。
- 在你的 `class` 或 `template` 所在的命名空间内提供一个 `non-member swap`，并令它调用上述 `swap` 成员函数，并对 `classes` 特化 `std::swap`.
- 如果你正在编写一个 `class`，为你的 `class` 特化 `std::swap`，并令它调用你的 `swap` 成员函数
- 确定包含一个 `using` 声明式
- 为『用户定义类型』进行 `std templates` 全特化是好的，但千万不要尝试在 `std` 内加入某些对 `std` 而言全新的东西。
