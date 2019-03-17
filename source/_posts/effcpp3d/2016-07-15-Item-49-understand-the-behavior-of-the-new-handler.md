---
title: 『Effective C++ 读书笔记49』 了解 new-handler 的行为
date: 2016-07-15 19:28:33
tags:
  - cpp
---

C++ 允许开发人员手工管理内存，在多线程环境下，由于 heap 是一个可被改动的全局性资源，在多线程环境中容易出现竞速状态，如果没有适当的同步控制，调用内存代码可能很容易导致管理 heap 的数据结构内容败坏。当 operator new 无法满足某一内存分配需求时，它会抛出异常。当 openrator new 抛出异常以反映一个未满足的内存需求之前，它会先调用一个客户指定的错误处理函数，一个所谓的 new-handler。为了指定这个『用以处理内存不足』的函数，客户必须调用 set_new_handler，那是申明于 `new` 的一个标准程序库函数。

<!-- more -->

```cpp
namespace std{
  typedef void (*new-handler)();
  new-handler set_new_handler(new-handler p) throw();
}
```

set_new_handler 参数是一个指针，指向 operator new 无法分配足够内存时该被调用的函数。其返回值也是一个指针，指向 set_new_handler 被调用前正在执行的那个 new-handler 函数。
```cpp
#include <iostream>
#include <new>

using namespace std;

void outOfMen()
{
    std::cerr << "Unable to satisfy request for memory\n";
    std::abort();
}
int main()
{
    std::set_new_handler(outOfMen);
    int* pBigDataArray = new int[100000000000000000L];

    delete [] pBigDataArray;

    return 0;
}
```

输出为：
```bash
main(48319,0x7fff98322340) malloc: *** mach_vm_map(size=400000000000000000) failed (error code=3)
*** error: can\'t allocate region
*** set a breakpoint in malloc_error_break to debug
Unable to satisfy request for memory
[1]    48319 abort      ./main
```
一个设计良好的 new-handler 函数必须做一下事情：

- 让更多内存可被使用
- 安装另一个 new-handler
- 卸除 new-handler
- 抛出 bad_alloc 的异常
- 不返回

有时候需要依不同情况以不同的方式处理内存分配失败的情况，如针对不同的类，使用不同的处理函数。
```cpp
class X{
public:
  static void outOfMemory();
  ...
};
class Y {
public:
  static void outOfMemory();
  ...
};
X * p1 = new X;
Y * p2 = new Y;
```

C++ 并不支持 class 专属之 new-handler

```cpp
class Widget{
public:
  static std::new_handler set_new_handler(std::new_handler p) throw();
  static void* operator new(std::size_t size) throw(std::bad_alloc);
private:
  static std::new_handler currentHandler;
};
```
static 成员必须在 class 定义式之外被定义，可以这么写 `std::new_handler Widget::currentHandler = 0`;

Widget 内的 set_new_handler 函数会将它获得的指针存储起来，然后返回先前存储的指针，这也正是标准版 set_new_handler 的作为：
```cpp
std::new_handler Widget::set_new_handler(std::new_handler p) throw()
{
  std::new_handler oldHandler = currentHandler;
  currentHandler = p;
  return oldHandler;
}
```
Widget 的 new 做一下事情：
- 调用标准的 set_new_handler，告知 Widget 的错误处理函数。
- 调用 global operator new，执行实际之内存分配。
- 如果 global operator new 能够分配足够一个 Widget 对象所用的内存， Widget 的 operator new 会返回一个指针，指向分配所得。

```cpp
class NewHandlerHolder{
public:
  explicit NewHandlerHolder(std::new_handler nh)
  :handler(nh){}
  ~NewHandlerHolder()
  {
    std::set_new_handler(handler);
  }
private:
  std::set_new_handler handler;
  NewHandlerHolder(const NewHandlerHolder&);
  NewHandlerHolder&
    operator=(const NewHandlerHolder&);
};
```
Widget's operator new 的实现
```cpp
void* Widget::operator new(std::size size) throw(std::bad_alloc)
{
  NewHandlerHolder h(std::set_new_handler(currentHandler));
  return ::operator new(size);
}
```


---

- set_new_handler 允许客户指定一个函数，在内存分配无法获得满足时被调用
-  Nothrow new 是一个颇为局限的工具，因为它只适用于内存分配；后继的构造函数调用还是可能抛出异常。
