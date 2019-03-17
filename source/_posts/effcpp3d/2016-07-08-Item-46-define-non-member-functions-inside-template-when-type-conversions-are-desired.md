---
title: Item 46 需要类型转换时请为模板定义非成员函数
date: 2016-07-08 10:29:10
tags:
  - Effective cpp
---

条款 24 讨论为什么唯有 non-member 函数才有能力『在所有实参身上实施隐式类型转换』，该条款并以 Rational class 的 operator* 函数为例。本条款将 Rational 和 operator\* 模板化了：
<!-- more -->
```cpp
template <typename T>
class Rational {
public:
...
  friend const Rational operator*(const Rational& lhs, const Rational& rhs);
};

template <typename T>
const Rational<T> operator*(const Rational<T>& lhs, const Rational<T> & rhs)
{ ... }
```

像条款 24 一样，本意是希望支持混合式算术运算。模板实参推导过程从不将隐式类型转换函数纳入考虑。此处的 friend 与传统的 friend 用法大相径庭。 **为了让所有的类型转换可能发生于所有的实参身上，我们需要一个 non-member 函数；为了令这个函数被自动具现化，我们需要将它声明在 class 内部；而在 class 内部声明 non-member 函数的唯一方法就是： 令它成为一个 friend。**



```cpp
template <typename T>
class Rational {
public:
...
  friend const Rational operator*(const Rational& lhs, const Rational& rhs)
  {
    return ...
  }
};
```


---

- 当我们编写一个 `class template`，而它所提供之『以此模板相关的』函数支持『所有参数之隐式转换』时，可将那些函数定义为『class 模板 内部的 `friend` 函数』。
