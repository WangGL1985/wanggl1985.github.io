---
title: 『Effective C++ 读书笔记23』 宁以 non-member,non-friend 替换 member 函数
date: 2016-07-05 16:08:44
tags:
  - cpp
---

假设有个 `class` 用来表示网页浏览器。这样的 `class` 可能提供的众多函数，区分多种功能。

<!-- more -->
```cpp
class WebBrowser{
public:
  ...
  void clearCache();
  void clearHistory();
  void removeCookies();
  ...
};
```
如果想一键清除所有

```cpp
class WebBrowser{
public:
  ...
  void clearEverything();                   //调用 clearCache， clearHistory， removeCookies
  ...
};
```

或使用非成员函数调用成员函数来实现
```cpp
void clearBrower(WebBrowser& wb)
{
  wb.clearCache();
  wb.clearHistory();
  wb.removeCookies();
}
```

如何评判哪一种方式更好呢？从封装性角度看，如果某些东西被封装，它就不再可见，越少代码可以看到数据，越多数据可被封装。以『计算能够访问该数据的函数数量』，即越多的函数访问，数据的封装性越差。

注意：论述只适用于 `non-member， non-friend` 函数，因为在意封装性而让函数『成为 `class` 的 `non-member`』，并不意味它『不可以是另一个 `class` 的 `member` 』。例如可以令 `clearBrower` 成为工具类（ `utility class` ）的一个 `static member`函数。只要它不是 `WebBrower` 的一部分，就不会影响 `WebBroser` 的 `private` 成员的封装性。

将所有便利函数放在多个文件内但隶属同一个命名空间，意味客户可以轻松扩展这一组便利函数。他们需要做的就是添加更多 non-member non-friend 函数此命名空间内。

---

-宁可拿 `non-member non-friend` 函数替换 `member` 函数。这样做可以增加封装性、包裹弹性和机能扩充性。
