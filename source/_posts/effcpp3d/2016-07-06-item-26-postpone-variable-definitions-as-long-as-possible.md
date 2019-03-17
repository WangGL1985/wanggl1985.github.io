---
title: 『Effective C++ 读书笔记26』 尽可能延后变量定义式的出现时间
date: 2016-07-06 10:11:45
tags:
  - cpp
---

大多数情况下，适当提出你的 `classes` 定义以及 `functions` 声明，是花费最多心力的两件事。但是问题依然有很多：

- 太快定义变量可能造成效率上的拖延
- 过度使用转型
- 返回对象可能会破坏封装性
- 异常的冲击问题
- 过度的 `inline`
- 过度耦合
- ...

<!-- more -->
当定义一个变量而其类型带有一个构造函数或析构函数，当程序的控制流到达这个变量定义式时，便得承受构造成本，当这个变量离开作用域时，你便得承受析构成本。

有没有可能你定义了一个不使用的变量？

```cpp
std::string encryptPassword(const std::string& password)
{
  using namespace std;
  string  encrypted;
  if (password.length() < MinimumPasswordLength) {
    throw logic_error("password is too short");
  }
  ...
  return encrypted;
}
```
如果函数丢出异常，变量 encrypted 则并没有被使用，最好延后变量的定义，直到真正需要它
```cpp
std::string encryptPassword(const std::string& password)
{
  using namespace std;
  if (password.length() < MinimumPasswordLength) {
    throw logic_error("password is too short");
  }
  string  encrypted;
  ...
  return encrypted;
}
```
美中不足的是 encrypted 会有一个 default 构造函数调用。**最好的方法是以 `password` 作为 `encrypted` 的初值，跳过毫无意义的 `default` 构造过程。**

```cpp
std::string encryptPassword(const std::string& password)
{
  string  encrypted(password);
  ...
  return encrypted;
}
```
但如果变量只在循环内使用，一下两种做法谁更好呢？

方法 A
```cpp
Widget w;
for(int i = 0; i < n; ++i){
  w = 与 i 相关
}
```
方法 B
```cpp
for(int i = 0; i < n; ++i){
  Widget w;
  ...
}
```
两种做法的消耗为：

> A: 1 constructor + n deconstructor + n assignment \b
> B: n deconstructor + n deconstructor

通常情况下，应该使用做法 B。
---
- 尽可能延后变量定义式的出现(激活 copying 构造函数)，这样做可增加程序的清晰度并改善程序效率
