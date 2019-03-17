---
title: 『Effective C++ 读书笔记42』 了解 typename 的双重意义
date: 2016-07-20 09:18:02
tags:
  - Effective cpp
---

从 `C++` 的角度来看，声明 `template` 参数时，不论使用关键字 `class` 或 `typename` 意义完全相同。然而 c++ 不总是把 class 和 typename 视为等价。有时候得使用 typename。

<!-- more -->
```cpp
#include <vector>
#include <iostream>

using namespace std;


    template <typename C>
void print2nd(const C& container)
{
    if (container.size() >= 2) {
        typename C::const_iterator iter(container.begin());
        ++iter;
        cout << *iter << endl;
    }
}

int main()
{
    std::vector<int> vec{1,2, 3, 4,5};
    print2nd(vec);

    return 0;
}
```
在 `C++` 中， `iter` 声明式只有在 `C::const_iterator` 是个类型时才合理，但我们并没有告诉 `C++` 说它是，于是 `C++` 假设它不是。解决方法如上。


---

- 声明 `template` 参数时，前缀关键词 `class` 和 `typename` 可互换
- 使用关键字 `typename` 标识嵌套从属类型名称；但不得在 `base class lists` 或 `member initialization list` 内以它作为 `base class` 修饰符。
