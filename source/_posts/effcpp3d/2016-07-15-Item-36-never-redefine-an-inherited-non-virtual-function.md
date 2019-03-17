---
title: 『Effective C++ 读书笔记36』 绝不重新定义继承而来的 non-virtual 函数
date: 2016-07-15 10:38:41
tags:
  - cpp
---

class D 系由 class B 以 public 形式派生而来， class B 定义一个 public 成员函数 mf。

<!-- more -->
```cpp
class B{
public:
  void mf();
  ...
};
class D: public B { ... };
```
对于类型为 D 的对象 x
- 行为一

  ```cpp
  B* pB = &x;
  pB->mf();
  ```
- 行为二

  ```cpp
  D* pD = &x;
  pD->mf();
  ```
---
任何情况下都不要重新定义继承而来的 `non-virtual` 函数。
