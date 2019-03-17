---
title: 『Effective C++ 读书笔记41』  理解隐式接口和编译期多态
date: 2016-07-19 08:34:51
tags:
  - cpp
---

面向对象编程世界总是以显式接口和运行期多态解决问题。『显式接口』是指在源代码中明确可见。`Templates` 及泛型编程的世界，与面向对象有根本上的不同。『显式接口』和『运行期多态』仍然存在，但重要性降低。『隐式接口』和『编译期多态』移到了前头了。

<!-- more -->
```cpp
template <typename T>
void doProcessing(T& w) {
  if (w.size() > 10 && w != someNastyWidget) {
    T temp(w);
    temp.normalize();
    temp.swap(w);
  }
}
```
- `w` 必须支持哪一种接口，由 `template` 中执行于 `w` 身上的操作来决定。
  - `size`
  - `normalize`
  - `swap`
  - `copy` 构造函数
  - `!=` 比较
- 凡涉及 `w` 的任何函数调用，都可能造成 `template` 具现化，使这些调动得以成功。这样的具现行为发生在编译期。『以不同的 `template` 参数具现化 `function templates` 会导致调用不同的函数』，即所谓的编译器多态。

『运行期多态』和『编译器多态』就类似于『哪一个 `virtual` 函数该被绑定』和『哪一个重载函数该被调用』。

通常显式接口由函数的签名式（函数名称、参数类型、返回类型）构成。例如
```cpp
class Widget{
public:
  Widget();
  virtual ~Widget();
  virtual std::size_t size() const;
  virtual void normalize();
  void swap(Widget& other);
};
```
『隐式接口』是基于有效表达式组成
```cpp
template <typename T>
void doProcessing(T& w) {
  if (w.size() > 10 && w != someNastyWidget) {
    ...
  }
}
```
- `T` 的隐式接口必须提供一个名为 `size` 的成员函数，该函数返回一个整数值
- `T` 必须支持一个 `operator !=` 函数，用来比较两个 `T` 对象。

加诸于 `template` 参数身上的隐式接口，就像加诸于 `class` 对象身上的显示接口一样真实，而且两者都在编译器完成检查。

---

- `classes` 和 `templates` 都支持接口和多态
- 对 `classes` 而言接口是显示，以函数签名式为中心。多态则是通过 `virtual` 函数发生于运行期。
- 对 `template` 参数而言，接口是隐式的，奠基于有效表达式。多态则是通过 `template` 具现化和函数重载解析发生于编译期。
