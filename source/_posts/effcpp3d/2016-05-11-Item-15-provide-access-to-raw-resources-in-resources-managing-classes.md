---
layout: post
title: 『Effective C++ 读书笔记15』 在资源管理类中提供对原始资源的访问
date: 2016-05-11
tags:
  - cpp
---

为了实现对象管理资源，我们可以依赖智能指针，但有时需要直接访问原始资源。场景如下，使用智能指针如 auto_ptr 或 tr1::shared_ptr 保存 factory 函数如 createInvestment 的调用结果：

<!-- more -->
```cpp
std::tr1::shared_ptr<Investment> pInv(createInvestment());
```
存在以下函数处理 Investment 对象：

```cpp
int daysHeld(const Investment* pi);
int days  = daysHeld(pInv);
```
如果这样调用它显然不对，因为 daysHeld 需要的是一个 Investment 对象，而不是 shared_ptr 对象。这时你需要一个函数可将 RAII 类对象转换为原始资源。通过『显示转换』或『隐式转换』即可达到目的。 `tr1::shared_ptr` 和 `auto_ptr` 都提供一个 `get` 成员函数，用来执行显式转换，返回智能指针内部的**原始指针**。


```cpp
int days = daysHeld(pInv.get());
```
也可以隐式转换至底部原始指针
```cpp
class Investment{
public:
  bool isTaxFree() const;
  ...
};
Investment* createInvestment();
std::tr1::shared_ptr<Investment> pi1(createInvestment());
bool taxable1 = !(pil->isTaxFree());
```

为了方便取得 RAII 对象内的**原始资源**，做法是提供一个隐式转换函数
```cpp
 FontHandle getFont();
 void releaseFont(FontHandle fh);
 class Font{
 public:
   explicit Font(FontHandle fh)
   :f(fh){}
   
   ~Font(){ releaseFont(f);}
   private:
     FontHandle f;
 };
```
可以提供一个显示转换函数
```cpp
class Font()
{
  ...
  FontHandle get() const { return f;}
  ...
};

```
但是，这将使得客户每当想要使用 API 时就必须调用 get：

```cpp
void changeFontSize(FontHandle f, int newSize);
Font f(getFont());
int newFontSize();
...
changeFontSize(f.get(),newFontSize);                  //将 Font 转换为 FontHandle
```
另一个办法是提供隐式转换函数，将 Font 转型为 FontHandle：

```cpp
class Font{
public:
  ...
  operator FontHandle() const
  {
    return f;
  }
  ...
};
```
客户下如下代码：
```cpp
Font f(getFont());
int newFontSize;
...
changeFontSize(f,newFontSize);
```


---

-	`APIs` 往往要求访问原始资源，所以每一个 `RAII class` 应该提供一个『取得其所管理之资源』的方法。
-	对原始资源的访问可能经由显示转换或隐式转换。一般而言显式转换比较安全，但隐式转换对客户比较方便
