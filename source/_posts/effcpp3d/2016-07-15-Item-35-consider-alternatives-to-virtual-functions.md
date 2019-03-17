---
title: 『Effective C++ 读书笔记35』 考虑 virtual 以外的其他选择
date: 2016-07-15 13:47:43
tags:
  - cpp
---


多重继承的意思是继承一个以上的基类，防止不要发生 `钻石形`。

<!-- more -->
```cpp
class File { ... };
class InputFile: virtual public File()
...
```

`Public` 继承应该总是 `virtual`。虚基类初始化也需要成本
- `classes` 若派生自 `virtual bases` 而需要初始化，必须认知其虚基
- 当一个新的派生类加入继承体系中，它必须承担其 `virtual bases` 的初始化责任
