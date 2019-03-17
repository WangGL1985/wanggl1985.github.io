---
layout: post
title: 『Effective C++ 读书笔记14』 资源管理类中小心 copying 行为
date: 2016-05-09
tags:
	- cpp
---

`auto_ptr`、`shared_ptr` 等智能指针多数表现在 `heap-based` 资源上，在其他资源上，可能需要建立自己的资源管理类。

<!-- more -->
假设使用 `C API` 函数处理类型为 `Mutes` 的互斥器对象，共有 `lock` 和`unlock` 两函数可用：

```cpp
void lock(Mutex* pm);
void unlock(Mutex* pm);
```

为确保绝不会忘记将一个被锁住的 `Mutex` 解锁，需要建立一个 `class` 用来管理机锁，这样的 class 的基本结构由 RAII 守则支配，即『资源在构造期间获得，在析构期间释放』。

```cpp
#include <mutex>

using namespace std;

class Lock{
    public:
        explicit Lock(mutex* pm)
            :mutexPtr(pm)
        {
            //lock(mutexPtr);
            mutexPtr->lock();
        }

        ~Lock()
        {
            //unlock(mutexPtr);
            mutexPtr->unlock();
        }
    private:
        mutex* mutexPtr;
};

int main()
{
    return 0;
}
```

客户对 `Lock` 的用法符合 RAII 方式：

```cpp
Mutex m;
...
{
	Lock m1(&m);
	...																	//在区块最末尾，自动接触互斥器锁定
}
```

当存在复制操作时，会发生什么？

```cpp
Lock m11(&m);
Lock m12(m11);
```

当一个 `RAII` 对象被复制时，大多数时候会有两种操作

-	禁止复制

```cpp
#include <mutex>

using namespace std;

class Uncopyable
{
    public:
        Uncopyable(){}
        ~Uncopyable(){}

    private:
        Uncopyable(const Uncopyable&);
        Uncopyable& operator=(const Uncopyable&);
};
class Lock : private Uncopyable
{
    public:
        explicit Lock(mutex* pm)
            :Uncopyable()
             ,mutexPtr(pm)
    {
        //lock(mutexPtr);
        mutexPtr->lock();
    }

        ~Lock()
        {
            //unlock(mutexPtr);
            mutexPtr->unlock();
        }
    private:
        mutex* mutexPtr;
};

int main()
{
    return 0;
}
};
```
-	对底层资源祭出『引用计数法』, 使用 `tr1::shared_ptr` 指定『删除器』，是一个函数或函数对象，当引用计数为 0 时调用。

```cpp
#include <mutex>

using namespace std;

class Lock{
    public:
        explicit Lock(mutex* pm)
            :mutexPtr(pm)
        {
            //
            //lock(mutexPtr);
            mutexPtr.get()->lock();
        }

        ~Lock()
        {
            //unlock(mutexPtr);
            mutexPtr.get()->unlock();
        }
    private:
        std::shared_ptr<mutex> mutexPtr;
};
int main()
{

    return 0;
}
	```
-	深度拷贝，只要你喜欢，可以对一份资源有其任意数量的附件。
-	转移底部资源的拥有权，即 auto_ptr 的复制意义,当在任何时候都必须保证只有一个 RAII 指向一个未加工资源。

---

-	复制 `RAII` 对象必须一并复制它所管理的资源，所以资源的 `copying` 行为决定 `RAII` 对象的 `copying` 行为
-	普遍而常见的 `RAII class copying` 行为是：抑制拷贝，施行引用计数法。
