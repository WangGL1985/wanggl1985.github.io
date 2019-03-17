---
layout: post
title: 『Effective C++ 读书笔记12』  复制对象时勿忘其每一个成分（Copy all parts of an object）
date: 2016-05-06
tags:
	- cpp
---

当你声明了自己的 `copying` 函数，编译器就会『放松警惕』。 考虑一个 `class` 用来表现顾客，其中手工写出 `copying` 函数，使得外界对它们的调用会被 `logged` 下来。

<!-- more -->
```cpp
//main.cpp
#include <iostream>
#include <string>


using namespace std;

void logCall(const std::string& funcName)
{
    cout << funcName << endl;
}


class Customer{
    public:
        Customer(){}
        Customer(const Customer& rhs);
        Customer& operator=(const Customer& rhs);
    private:
        std::string name;
};

Customer::Customer(const Customer& rhs)
    :name(rhs.name)
{
    logCall("Customer copy constructor");
}

Customer& Customer::operator=(const Customer& rhs)
{
    logCall("Customer copy assignment operator");
    name = rhs.name;
    return *this;
}

int main()
{
    Customer cu1;
    Customer cu2(cu1);

		return 0;
}
```

一切看起来都很好，但是当加入一个元素后.此时， copying 函数只是复制了部分的成员变量， 且很多编译器不会对这样的错误给出任何警告。

```cpp
class Date{};
class Customer{
public:
	...
private:
	std::string name;
	Date lastTransaction;
};
```

当为派生类撰写 `copying` 函数时，必须小心地复制其基类的成分。但基类的成分往往是 `private` ，所以你应该让 `derived class` 的 `copying` 函数调用相应的 `base class` 函数。

```cpp
#include <iostream>
#include <string>


using namespace std;

void logCall(const std::string& funcName)
{
    cout << funcName << endl;
}


class Customer{
    public:
        Customer(){}
        Customer(const Customer& rhs);
        Customer& operator=(const Customer& rhs);
    private:
        std::string name;
};

Customer::Customer(const Customer& rhs)
    :name(rhs.name)
{
    logCall("Customer copy constructor");
}

Customer& Customer::operator=(const Customer& rhs)
{
    logCall("Customer copy assignment operator");
    name = rhs.name;
    return *this;
}
class PriorityCustomer : public Customer
{
    public:
        PriorityCustomer(const PriorityCustomer&);
        PriorityCustomer& operator=(const PriorityCustomer&);

    private:
        int priority;

};


PriorityCustomer::PriorityCustomer(const PriorityCustomer& rhs)
    :Customer(rhs), 															// 基类 copy 构造函数
    priority(rhs.priority)
{
}

    PriorityCustomer&
PriorityCustomer::operator=(const PriorityCustomer& rhs)
{
    Customer::operator=(rhs);
    priority = rhs.priority;
    return *this;
}
int main()
{
    Customer cu1;
    Customer cu2(cu1);

		return 0;
}

```

当编写 copying 函数时，（1）确保拷贝所有的 local 变量；（2）调用基类的 copying 函数。

但是，不能用 `copy assignment` 操作符调用 `copy` 构造函数。当发现 `copy` 构造函数和 `copy assignment` 操作符有相近的代码，消除的方法是定义一个 `private` 的 `init` 函数。

---

-	`copying` 函数应该确保复制『对象内的所有成员变量』及『所有基类成分』
-	不要尝试以某个拷贝函数实现另一个拷贝函数。应该将共同机能放进第三个函数中，并且两个拷贝函数共同调用。
