---
title: 『Effective C++ 读书笔记43』 学习处理模板化基类内的名称
date: 2016-07-21 09:42:37
tags:
  - cpp
---

如果在编译期间需要足够的信息来决定具体执行哪些函数，可以采用基于 template 的方法。当编译器遇到『类模板类定义时』，并不知道它继承什么样的类。因为其中的模板参数不到类被具现化，无法确切知道它是什么。

<!-- more -->
```cpp
class CompanyA{
public:
  ...
  void sendCleartext(const std::string& msg);
  void sendEncryted(const std::string& mgs);
};
class CompanyB{
public:
  ...
  void sendCleartext(const std::string& msg);
  void sendEncryted(const std::string& mgs);
};
...
class MsgInfo{...};
template<typename Company>
class MsgSender{
public:
  ...
  void sendClear(const MsgInfo& info)
  {
    std::string msg;
    Company c;
    c.sendCleartext(msg);
  }
  void sendSerect(const MsgInfo& info)
  {...}
};
```
假设每次送出信息时登记某些信息，可以实现如下
```cpp
template<typename Company>
class LoggingMsgSender: public MsgSender<Company>{
public:
  ...
  void sendClearMsg(const MsgInfo& info)
  {
    ...
    sendClear(info);
    ...
  }
  ...
};
```
但这样的实现无法通过编译，因为当编译器遇到 `class template LoggingMsgSender` 定义式时，并不知道它继承什么样的 class。它继承的 MsgSender<Company> ，但其中的 Company 是个 template 参数，不到后来无法确切知道它是什么。解决办法由三种：

```cpp
template<typename Company>
class LoggingMsgSender: public MsgSender<Company>{
    public:
      //method 1
        /*void sendClearMsg(const MsgInfo& info)
          {
          this->sendClear(info);
          }*/

      //method 2
        /*using MsgSender<Company>::sendClear;

          void sendClearMsg(const MsgInfo& info)
          {
          sendClear(info);
          }*/

      //method 3
        void sendClearMsg(const MsgInfo& info)
        {
            MsgSender<Company>::sendClear(info);
        }
};
```

假设需要一个 class CompanyZ 坚持使用加密通讯：
```cpp
class CompanyZ{
public:
  ...
  void sendEncryted(const std::string& msg);
  ...
};
```
一般性的 MsgSender template 对 CompanyZ 并不合适，可以使用模板全特化的方式
```cpp
template<>
class MsgSender<CompanyZ>{
public:
  ...
  void sendSerect(const MsgInfo& info) {
    ...
  }
};
```
`class` 定义式最前头的 `template<>` 语法象征这既不是 `template` 也不是标准 `class`，而是个特化版的 `MsgSender template`， 在 `template` 实参是 `CompanyZ`时被使用。

---

- 可在 `derived class templates` 内通过 `this->` 指涉 `base class templates` 内的成员名称，或藉由一个明白写出的 `base class 资格修饰符`完成。
