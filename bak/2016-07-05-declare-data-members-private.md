---
title: Item 22 将成员变量声明为 private
date: 2016-07-05 15:38:00
tags:
  - Effective cpp
---


成员变量不该是 `public`， 也不该是 `protected`， 成员变量应该是 `private`.如果成员变量不是 `public`，客户唯一能够访问对象的方法就是通过成员函数。使用函数可以让你对成员变量的处理有更精确的控制。

如果你令成员变量为 public，每个人都可以读写它，但如果你以函数取得或设定其值，你就可以实现出『不准访问』、『只读访问』以及『读写访问』。

```cpp
class AccessLevels{
public:
  ...
  int getReadOnly() const { return readOnly; }
  void setReadWrite(int value){ readWrite = value; }
  int getReadWrite(){return readWrite;}
  void setWriteOnly(int value) { writeOnly = value; }
private:
  int noAccess;
  int readOnly;
  int readWrite;
  int writeOnly;
};
```

成员变量 `private`的最主要原因是『封装』，如果你通过函数访问成员变量，日后可改以某个计算替换这个成员变量，而 `class` 客户一点也不会知道 `class` 的内部实现已经起了变化。从封装的角度观察，其实只有两种访问权限: private (提供封装)和其他（不提供封装）。

---

- 将成员变量声明为 `private`，可以赋予客户端访问数据的一致性、可细微划分访问控制、并提供 `class` 作者以充分的实现弹性
- `protected` 并不比 `public` 更具封装性
