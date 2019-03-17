---
title: 『Effective C++ 读书笔记21』 必须返回对象时，别妄想返回其 reference
date: 2016-05-23 15:12:57
tags:
  - cpp
---

考虑一个用以表现有理数的 `class`， 内含一个函数用来计算两个有理数的乘积。

<!-- more -->
```cpp
class Rational{
public:
  Rational(int numerator = 0, int denominator = 1);
  ...
private:
  int n, d;
  friend const Rational operator* (const Rational& lhs,const Rational& rhs);
};
```

任何时候当你看到 `refernece `时，都应该想到这只是一个名称，那么它另一个名字是什么？因为它一定是某物的另一个名称。函数返回一个 `reference`。

```cpp
const Rational& operator* (const Rational& lhs,const Rational& rhs)
{
  Rational result(lhs.n * rhs.n, lhs.d * rhs.d);
  return result;
}
```
此处 `result` 是一个 `local` 对象，函数返回后将不复存在。考虑在 heap 内构造一个对象，并返回 reference 指向它。Heap-based 对象由 new 创建，所以你得写一个 heap-based operator* 如下：

```cpp
const Rational& operator* (const Rational& lhs, const Rational& rhs)
{
  Rational* result = new Rational(lhs.n * rhs.n, lhs.d * rhs.d);
  return *result;
};
```
如果出现这样的调用，你还能保证不出现内存泄露吗？

```cpp
Rational w,x,y,z;
w = x*y*z;
```
还有一种方法就是返回一个 local static 的对象，但是但出现下列用法时，还是会出问题的。
```cpp
bool operator==(const Rational&, const Rational&)
{ }

Rational a, b, c, d;
if ((a * b == c * d))
```
这样的表达式将永远返回 true， 因为两次 operator* 都各自改变了 result 的值， 但因为返回的是引用，所以调用端总是显示为『现值
』。

当必须在『返回一个reference 和返回一个 object』之间抉择时，就让返回一个新对象吧。

---

- 绝不要返回 `pointer` 或 `reference` 指向一个 `local stack`对象 (local stack object 自动删除)
- 绝不要返回 `reference` 指向一个 `heap-allocated` 对象 (谁负责删除)
- 绝不要返回 `pointer` 或 `reference` 指向一个 `local static` 对象而有可能同时需要多个这样的对象。
- 参考条款 4（使用专属函数用以返回 local static object）
