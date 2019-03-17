---
title: Item 45 运用成员函数模板接受所有兼容类型
date: 2016-07-08 10:16:34
tags:
  - Effective cpp
---

# `Templates` 和泛型编程

<!-- more -->
```cpp
template <typename T>
class SmartPtr {
private:

public:
  template <typename U>
  SmartPtr (const SmartPtr<U>& other);
  virtual ~SmartPtr ();
};
```
`u` 和 `t` 的类型是同一个 `template` 的不同具现体，称为泛化 `copy` 构造函数。

# 总结

- 请使用 `member function template` 生成『可接受所有兼容类型』的函数
- 如果你声明 `member template` 用于『泛化 `copy` 构造 』或 『泛化赋值操作』，你还是需要声明正常的 `copy` 构造函数和 `copy assignment` 操作符。
