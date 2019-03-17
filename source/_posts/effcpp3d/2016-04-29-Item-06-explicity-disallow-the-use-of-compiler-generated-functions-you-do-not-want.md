---
layout: post
title: 『Effective C++ 读书笔记6』 若不想使用编译器自动生成的函数，就该明确拒绝
date: 2016-04-29
tags:
	- cpp
---

现实生活中，往往同一类的两个个体之间是独一无二的，如果以一个 `C++` 类来代表现实中的某个事物，则进行拷贝赋值或拷贝构造函数是不符合现实情形的。所以，在这种情况下，你并不需要有 `copying` 构造函数和 `copying assignment` 操作符存在。

<!-- more -->
通常你不希望 `class` 支持某一特定机能，只要不声明对应函数就是了。但这个策略对 `copy` 构造函数和 `copy assignment` 操作符却不起作用。好消息是，所有编译器产生出的函数都是 `public`。可以将拷贝构造函数和拷贝赋值操作符声明为 `private`，则可以成功阻止别人调用。


![](http://olkbjcb09.bkt.clouddn.com/blog/2017-04-19-142545.jpg)
```cpp
class HomeForSale{
public:
	...
private:
	...
	HomeForSale(const HomeForSale&);
	HomeForSale& operator=(const HomeForSale&);  //只有声明
};
```

注意，上述代码并没有定义拷贝构造函数和拷贝赋值操作符的函数体。所以，如果有成员函数或友元函数调用，则会产生**连接错误**。但是通常连接错误不好处理，所以将连接期错误移至编译期：

```cpp

class Uncopyable
{
    public:
        Uncopyable(){

        }
        ~Uncopyable()
        {

        }

    private:
        Uncopyable(const Uncopyable&);
        Uncopyable& operator=(const Uncopyable& rhs);
};
```
```cpp
#include "uncopyable.h"

class HomeForSale : private Uncopyable
{
    public:
        HomeForSale()
        {

        }

};
```
```cpp
#include "HomeForSale.h"


int main()
{
    HomeForSale tst1;
    HomeForSale tst2;

    //
    tst1 = tst2;

    return 0;
}
```

这样就将错误提到了编译期：
```bash
In file included from main.cpp:1:
./HomeForSale.h:3:7: error: 'operator=' is a private member of 'Uncopyable'
class HomeForSale : private Uncopyable
      ^
./uncopyable.h:14:21: note: declared private here
        Uncopyable& operator=(const Uncopyable& rhs);
                    ^
main.cpp:10:10: note: implicit copy assignment operator for 'HomeForSale' first required here
    tst1 = tst2;
         ^
1 error generated.
```

当有 `copying` 构造函数或 `copying assignment` 操作符调用时，由『编译器生成版』会尝试调用**基类**的对应兄弟，那些调用会被编译器拒绝，因为基类的拷贝构造函数是私有。

---

-	为驳回编译器自动提供的技能，可将相应的成员函数声明为 `private` 并且不予实现。
-	使用像 `Uncopyable` 这样的 `base class` 也是一种做法
