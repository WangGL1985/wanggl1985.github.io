---
title: 『Effective C++ 读书笔记30』 透彻了解 inlining 的里里外外
date: 2016-07-10 14:51:38
tags:
  - cpp
---

在 C 中，提高效率常用方式是使用宏，宏的外形和使用都和函数极为相似，宏节省了函数调用（pushing arguments, making an assembly-language CALL, returning arguments, and performing an assembly-language RETURN）所产生得额外开销。但是宏是由预处理器实现的，编译器无法检查，所以很难查找 bug。另外，在 C++ 中，预处理器不能访问类成员，即不能作为类的成员函数。

`Inline` 函数，看起来像函数，动作像函数，调用时没有函数调用所招致的额外开销。当你 inline 某个函数，或许编译器还会对 `inline` 函数执行语境相关最优化。`inline` 函数的整体观念是**对此函数的每一个调用都以函数本体替换之**但是这会增加你的目标码大小，造成程序体积太大。 `inline` 造成的代码膨胀亦会导致额外的换页行为，降低指令高速缓存装置的击中率，以及伴随而来的效率损失。


<!-- more -->
`inline` 只是对编译器的一个申请，可以明确提出，也可以隐喻提出（将函数定义于 `class` 定义式内）：
```cpp
class Person{
public:
  ...
  int age() const {return theAge;}
  ...
private:
  int theAge;
};
```
这样的函数通常是成员函数。明确声明 `inline`函数的做法是在其定义式前加上关键字 `inline`。
```cpp
template<typename T>
inline const T& std::max(const T& a, const T& b)
{
  return a < b ? b : a;
}
```
`inline` 函数一定在头文件内。 `inlining` 在大多数 `C++` 程序中是编译期行为，为了将一个『函数调用』替换为『被调用函数的本体』，编译器必须要知道那个函数长什么样子。

`Template` 通常也被置于头文件内，因为它一旦被使用，编译器为了将它具现化，需要知道它长什么样子。 Template 的具现化与 inlining 无关。如果认为根据你写的 `template` 具现出来的函数都应该是 `inlined` ，则将此 `template` 声明为 `inline`。所有对虚函数调用都会使 `inlining` 落空。因为虚函数意味着『等待、直到运行期才确定调用哪个函数』，而 inline 意味『执行前，先将调用动作替换为被调用函数的本体』。

如果以指针方式调用函数，在该函数会生成一个 `outlined` 函数本体。
```cpp
inline void f( ) {...}
void (*pf)() = f;
...
f(); //调用被 inlined， 因为是一个正常调用
pf(); //
```
决定那些函数被声明为 `inline` 而哪些不该时，策略是一开始先不要将任何函数声明为 `inline`。慎重使用 `inline` 便是对日后使用调试器带来帮助。

---

- 将大多数 `inlining` 限制在小型、被频繁调用的函数身上。
- 不要只因为 `function templates`出现在头文件，就将它们声明为 `inline`
