---
title: 『Effective C++ 读书笔记24』 若所有参数皆需要类型转换，请为此采用 non-member 函数
date: 2016-07-06 08:39:49
tags:
  - cpp
---

通常不建议 `classes` 支持隐式类型转换，但是在数值类型中，这条建议不再适用。

<!-- more -->
假设有这样一个 `Rational class`：
```cpp
class Rational {
public:
  Rational(int numerator = 0, int denominator = 1);               //构造函数可以不为 explicit
  int numerator() const;                                          //
  int denominator() const;
private:
  ...
};
```
先研究一下将 operator* 写成 Rational 成员函数的写法。

```cpp
class Rational{
public:
  ...
  const Rational operator* (const Rational& rhs) const;
}
```

当进行混合式相乘时

```cpp
result = oneHalf * 2;  //good
result = 2 * oneHalf;  //wrong
```
用函数的形式写出来就很直观了

```cpp
result = oneHalf.operator*(2);
result = 2.operator*(oneHalf);
```
因为， `oneHalf` 是一个内含 `operator*` 函数的 `class` 的对象，所以编辑器调用该函数。但是整数 `2` 并没有相应的 `class`。 将 `*` 写成非成员函数呢？

```cpp
class Rational{
  ...
};
const Rational operator*(const Rational& lhs, const Rational& rhs)
{
  return Rational(lhs.numerator() * rhs.numerator(),...)
}
```

好了，解决了。

---

- 如果你需要为某个函数的所有参数（包括被 `this` 指针所指的那个隐喻参数）进行类型转换(类的构造函数实现的隐式类型转换)，那么这个函数必须是个 `non-member`.
