---
layout: post
title: "『Effective C++ 读书笔记2』尽量以 const，enum，inline 替换 #define "
date: 2015-10-10
tags:
	- cpp
---


This Item might better be called "prefer the compiler to the perprocessor"『宁以编译器替换预处理器』, because `#define` may be treated as if it's not part of the language perse.

<!-- more -->
```cpp
#define ASPECT_RATIO 1.653
```

使用预处理器存在的问题是：记号 `ASPECT_RATIO` 也许从未被编译器看见，也许编译器开始处理源码之前他就被预处理器移走了。你所使用的名称可能并未进入记号表，则可能在你使用此常量时，得到一个编译器错误信息，而错误信息提到的却是 `1.653` ，解决方法就是使用常量代替预处理器。

> 为什么在 C++ 中摒弃宏呢？ C++ 强调强类型，可以帮助编译器自动发现程序员的错误。而 C 语言的哲学则是可显性，推荐程序『表里如一』。C 语言虽然类型较弱，但尽可能地把实际工作展现出来。绝大多数情况下，宏在语言中起到的作用是使程序更易读，可配置，而非改变语言的表现形式。


```cpp
const double AspectRatio = 1.653;
```

`const` 替换 `#define` 时，有两种特殊的情况：

# 定义常量指针(`constant pointer`)

通常常量指针定义式被放在头文件中(方便被不同源码含入)，因此有必要将『指针』声明为`const`，例如，在头文件中定义一个常量的 `char* based` 字符串。

```cpp
const char* const authorName = "Scott Meyers";
```
or
```cpp
const std::string authorName("Scott Meyers");
```

# `class`专属常量

**专属** -- 为了将常量的作用域限制于 `class` 内部，你必须让它成为 `class` 的一个成员。**为了确保此常量至多只有一份，必须使其成为一个 `static` 成员。**

```cpp
#include <iostream>

using namespace std;

class GamePlayer{
public:
	static const int NumTurns = 5;	//常量声明式
	int scores[NumTurns];
};

int main()
{
	GamePlayer gplayer;
	cout <<  gplayer.NumTurns << endl;  //ok

	return 0;
}
```


在 `C++` 中，如果 `class` 专属常量为 `static` 且为整数类型，只要不获取它们的地址，则可以声明并使用他们而无须提供定义式(没有定义式，则编译器不会分配内存空间，当然无法获得地址)。如果必须要定义式，则定义式的形式为 `const int GamePlayer::NumTurns;` ，且应该放在『实现文件』中。

```cpp
#include <iostream>

using namespace std;

class GamePlayer{
public:
	static const int NumTurns = 5;	//常量声明式
	int scores[NumTurns];
};

const int GamePlayer::NumTurns;

int main()
{
	GamePlayer gplayer;
	cout <<  &(gplayer.NumTurns) << endl;  // ok 因为已经给 NumTurns 提供的定义式。

	return 0;
}
```

如果**编译器**不支持 `static` 成员在其声明式上获得初值，可将初值放在定义式：

```cpp
//in header file
class Test
{
    public:
        static double getValue()
        {
            return testValue;
        }
    private:
        static const double testValue;
};
//in source file
#include "const-static-in-class.h"
#include <iostream>

using namespace std;

const double Test::testValue = 3.2;
int main()
{
    cout << Test::getValue() << endl;

    return 0;
}
```

# enum hack

当你的`class` 在编译期间需要一个 `class` 常量值，例如一个数组的大小。如果编译器不允许完成 `in class` 初值设定，可以改用 `the enum hack` 补偿，原理是『一个属于枚举类型的数值可权充 `ints` 被使用 』

```cpp
class GamePlayer{
private:
	enum { NumTurns = 5};

	int scores[NumTurns];
	...
};
```

`enum hack` 的行为某些方面像 `#define`，而不像 `const`，例如不能取一个`enum` 的地址。如果你不想让别人获得一个 `pointer` 或`reference` 指向你的某个整数常量，则可用 `enum` 实现这个约束。


# 使用 `#define` 定义宏


```cpp
#define CALL_WITH_MAX(a,b) f((a) > (b) ? (a) : (b))
```
如果有语句

```cpp
CALL_WITH_MAX(++a,b);
```
则 `a` 会加两次；


无论何时当你写出这种宏，你必须记住为宏中的所有实参加上小括号。宏的一个优点是看起来像函数，但不会招致函数调用带来的额外开销。**在 `C++` 中，可以使用 `template inline` 函数来代替宏的使用， 保证类型安全性的同时满足效率。**

```cpp
#include <iostream>

using namespace std;

    template <typename T>
inline T Max(const T& a, const T& b)
{
    return (a > b ? a : b);
}

int main()
{
    cout << Max(10, 23) << endl;

    return 0;
}
```

有了 consts，enums 和 inlines，我们对预处理器的需求降低了。但宏 `#include` 和 `#ifde/#endif` 等在控制编译中仍起着重要作用。

---

-	对于单纯常量，最好以 `const` 对象或 `enum` 替换 `#define`
-	对于形似函数的宏 (`macros`) ,最好改用 `Template inline` 函数替换 `#define`
