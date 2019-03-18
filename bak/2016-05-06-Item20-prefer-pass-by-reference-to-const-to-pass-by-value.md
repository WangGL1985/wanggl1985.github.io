---
layout: post
title: Item 20 宁以 pass-by-reference-to-const 替换 pass-by-value
date: 2016-05-06
tags:
  - "Effective cpp"
---

默认情况下 `C++` 以 `by value` 方式传递对象至函数。函数实际参数的副本由对象的『拷贝构造』函数产出，调用端所获得的亦是函数返回值的一个复件，这可能使得 `pass-by-value` 成为昂贵的操作。

<!-- more -->

```cpp
class Person{
public:
  Person();
  virtual ~Person();
  ...
private:
  string name;
  string address;
};

class Student: public Person{
public:
  Student();
  ~Student();
  ...
private:
  string schoolName;
  string schollAddress;
};
```
当执行如下代码
```cpp
bool validateStudent(Student s);
Student plato;
bool platoIsOK = validateStudent(plato);
```
就上述函数而言，参数的传递成本是 『一次 Student copy 构造函数调用，加上一次 Students 析构函数调用』。但是这不是全部，还有

- `Student` 对象内的两个 `string` 对象
- 一个父类 `Person` 对象
- `Person` 中的两个 `string`

所以，一次 `pass by value` 将导致调用一次 `Student`构造动作、一次 `Person copy` 构造函数、四次 `string copy` 构造函数。都函数内的复件被销毁时，又对应相应次数的析构函数的调用。

使用 `pass-by-reference-to-const` 可以避免上述过程中的所有的构造和析构。

```cpp
bool validateStudent( const Student& s);
```
这种参数传递方式不会引发任何的构造和析构，因为**没有新的对象被创建**。

`by reference` 方式传递参数可以避免 `slicing` 问题。当一个派生类对象以 `by value` 方式传递并被视为一个 `base class` 对象， `base class` 的 `copy` 构造函数被调用。

```cpp
class Window{
public:
  ...
  string name() const;
  virtual void display() const;
};
class WindowWithScrollBars: public Window{
public:
  ...
  virtual void display() const;
};
```

写个函数打印窗口名称，然后显示该窗口
```cpp
void printNameAndDisplay(Window w)
{
  std::cout << w.name();
  w.display();
}
```
当调用上述函数并交给它一个 `WindowWithScrollBars` 对象
```cpp
WindowWithScrollBars wwsb;
printNameAndDisplay(wwsb);
```


**一般而言，可以合理假设 `pass-by-value` 并不昂贵的唯一对象就是内置类型和 `STL` 的迭代器和函数对象。**

---

- 尽量使用 `pass-by-reference-to-const`，高效、且可避免切割问题。
- 对于内置类型和 `STL` 的迭代器和函数对象，使用 `pass-by-value`。
