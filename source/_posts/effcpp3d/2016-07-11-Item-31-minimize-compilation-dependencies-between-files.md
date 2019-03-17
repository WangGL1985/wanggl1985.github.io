---
title: 『Effective C++ 读书笔记31』 将文件间的编译依存关系降至最低
date: 2016-07-10 15:59:26
tags:
    - cpp
---

```cpp
class Person{
public:
  Person(const std::string& name, const Date& birthday, const Address& addr);
  std::string name() const;
  std string birthday() const;
  std::string address() const;
  ...
private:
  std::string theName;
  Date theBirthDate;
  Address theAddress;
};

```
这样的 class Person 无法通过编译（如果编译器没有取得其实现代码所用到的 class string， Date 和 Address 的定义式。这样的定义式通常由 #include 指示符提供。

<!-- more -->
这样会使得 person 定义文件和其含入文件之间形成了一种编译依存关系。这些头文件或这些头文件依赖的其他头文件有任何改变，那么每一个含入 Person class 的文件就得重新编译，任何使用 Person class 的文件也必须重新编译。

如果这样定义 person 是否可行

```cpp
namespace std{
   class string;
}
class Date;
class Address;
class Person{
public:
   Person(const std::string& name, const Date& birthday, const Address& addr);
   std::string name() const;
   std::string birthday() const;
   std::std::string address() const;
   ...
 };
```
有两个问题：
- string 不是一个类
- 编译器必须在编译器期间知道对象的大小

将对象实现细节隐藏于一个指针背后

```cpp
#include <string>
#include <memory>

class PersionImpl;
class Date;
class Address;

class Person{
public:
  Person(const std::string& name, const Date& birthday, const Address& addr);
  std::string name() const;
  std::string birthday() const;
  std::string address() const;
  ...
private:
  std::tr1::shared_ptr<PersionImpl> pImpl;                  /指向实现
}
```
这种分离的关键在于以『声明的依存性』替换『定义的依存性』。

- 如果 `object reference` 或 `object pointers` 可以完成任务，就不要使用 `objects`。可以只靠一个类型声明式就定义出指向该类型的 `references` 和 `pointers`；但如果要定义某类型的 `objects`， 就需要用到该类型的定义式。
- 如果能够，尽量以 `class` 声明式替换 `class` 定义式。当用到一个函数而它用到某个 `class` 时，你并不需要该 `class` 的定义；

```cpp
class Date;
Date today();
void clearAppointments(Date d) {
  /* code */
}
```

- 为声明式和定义式提供不同的文件，一个用于声明式，一个用于定义式。

```cpp
#include "datefwd.h"
Date today();
void clearAppointments(Date d);
```
例如， `C++` 标准库头文件的 <iosfwd>， <iosfwd>内含 `iostream` 各组件的声明式，其对应定义式则分布在若干不同的头文件内，包括 `<sstream>,<streambuf>,<fstream> 和 <iostream>`。

使用 `pimpl` 的 `classes`被称为 `Handle classes`。让其 `classes` 真正做事的方法就是将它们的所有函数转交给相应的实现类（ `implementation classes` ）并由后者完成实际工作。

```cpp
#include "Person.h"
#include "PersionImpl.h"

Person::Person(const std::string& name, const Date& birthday, const Address& addr)
:pImpl(new PersionImpl(name,birthday,addr))
{}

std::string Person::name() const
{
  return pImpl->name();
}
```


另一个制作 `Handle class` 的办法是，令 `Persion` 成为一种特殊的 `abstract base class`， 称为 `interface class`。这种 `class` 的目的是详细叙述 `derived classes` 的接口，它通常不带成员变量，没有构造函数，只有一个 `virtual` 析构函数以及一组 `pure virtual`函数。

```cpp
class Persion{
public:
  virtual ~Person();
  virtual std::string name() const = 0;
  virtual std::string birthday() const = 0;
  virtual std::string address() const = 0;
  ...
};
```
这个 `class` 的客户必须以 `Pointers` 和 `reference` 来撰写应用程序。 `Interface class` 的客户必须有办法为这种 `class` 创建新对象，它们通常调用一个特殊函数，由此函数扮演『正真将被具现化』的那个 `derived classes` 的构造函数角色。这样的函数通常被称为 `factory` 函数或 `virtual`构造函数。它们返回指针，指向动态分配所得对象，而该对象支持 `Interface class` 的接口。这样的函数一般声明为 static


```cpp
class Person {
public:
  ...
  static std::tr1::shared_ptr<Person>
  create(const std::string& name,const Date& birthday,const Address& addr);
  ...
};

```
客户可以这样使用

```cpp
std::string name;
Date dateOfBirth;
Address addredd;
...
std::tr1::shared_ptr<Persion>pp(Person::create(name,dateOfBirth,address));
...
std::cout<<pp->name()
         << "was born on "
         << pp->bitrhDate()
         << " and now lives at "
         << pp->address();
         ...
```
定义支持接口的具象类
```cpp
class RealPerson: public Person{
public:
  RealPerson(...)
  :theName(name),...
  {}
  virtual ~RealPerson(){}
  std::string name() const;
  ...
private:
  std::string theName;
  ...
```
实现 `create` 函数

```
std::tr1::shared_ptr<Person> Person::create(const std::string& name, const Date& birthday, const Address& addr)
{
  return std::tr1::shared_ptr<Person>(new RealPerson(name,bitrhDate,addr));
}
```

Handles classes 和 Ingerface classes 解除了接口和实现之间的耦合关系，从而降低文件间的编译依存性。

---
- 支持『编译依存最小化』的一般构想是：相依于声明，不要相依于定义式。基于此构想的两个手段是 `Handle classes` 和 `Interface classes`
- 程序库头文件应该是以『完全且仅有声明式』的形式存在。
