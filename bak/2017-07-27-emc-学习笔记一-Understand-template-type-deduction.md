---
title: 'emc++ 学习笔记一: Understand template type deduction'
date: 2017-07-27 16:13:46
tags:
  - emcpp
---

```cpp
template<typename T>
voud fun(const T& param);

int x = 0;
fun(x);
```


It's natural to expect that the type deducted for T is the same as the type of the argument passed to the function. But it doesn't always work that way. The type deduced for T is dependent not just on the type of `expr`, but also on the form of `paramType`.


That's because rx's reference-ness is ignored during type deduction.



### case2: paramType is a Universal Reference

Unuversal reference parameters are declared like rvalue reference, but they behave differently when lvalue arguments are passed in.

- If `expr` is an lvalue, both **T** and **ParamType** are deduced to be lvalue reference.That's doubly unusual.
  - First, it's the only situation in template type deduction where T is deduced to be a reference.
  - second, although **ParamType** is declared using the syntax for an rvalue reference, its deduced type is an lvalue reference
- If `expr` is an rvalue, the "normal" rules apply.

```cpp
template <typename T>
void fun(T&& param);

int x = 27;
const int cx = x;
const int& rx = x;

fun(x);                 //x is lvalue, so T is int&,
                        //param's type is also int&

fun(cx);                //cx is lvalue, so T is const int&
                        //param's type is also const int&

fun(rx);                // rx is lvalue, so T is const int&
                        //param's type is also const int&

fun(27);                // 27 is rvalue, so T is int
                        //param's type is therefore int&&

```

### case 3: ParamType is Neither a Pointer nor a Reference

When ParamType is neither a pointer nor a reference, we're dealing with pass-by-value:

```cpp
template <typename T>
void fun(T param);
```

- If `expr's` type is reference, ignore the reference part.
- If, after ignoring `expr's` reference-ness, expr is const, ignore that, too. If it's volatile, also ignore that.


```cpp
int x = 27;
const int cx = x;
const int& rx = x;

fun(x);                   // T's and param's types are both int
fun(cx);                  // T's and param's types are again both int
fun(rx);                  //T's and param's types are still both int
```


```cpp
template <typename T>
void fun(T param);


const char* const ptr = "Fun with pointer";
fun(ptr);                  //
```

The constness of what ptr points to is preserved during type deduction, but the constness of ptr itself is ignored when copying it to create the new pointer, param.






### Things to Remember

- During template type deduction, arguments that are references are treated as non-regerences, i.e., their referenceness is ignored.
- When deducing types for universal reference parameters, lvalue arguments get special treatment.
- When deducing types for by-value parameters, const and/or volatile arguments are treated as non-const and non-volatile.
- During template type deduction, arguments that are array or function names decay to pointers, unless they're used to initialize references.
