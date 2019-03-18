---
title: The decltype Type Specifier
date: 2016-11-23 22:53:51
tags:
---
Sometimes we want to define a variable with a typt that the compiler deduces from an expression but do not want to use that expression to initialize the variable. For such case, the new standard introduced a second type specifier, **decltype**, which returns the type of its operand. The compiler analyzes the expression to determine its type but does not evaluate the expression:

<!-- more -->

```c
decltype(f()) sum = x; // sum has whatever type of f returns
```

Here, the compiler does not call f, but it uses the type that such a call would return as the type for `sum`. That is, the compiler gives  `sum` the same type as the type that would be returned if we were to call f.


The way `decltype` handles top-level `const` and references differs subtly from the way `auto` does. When the expression to which we apply `decltype` is a variable,`decltype` returns the type of that variable, includeing top-level `const` and references:


```
const int ci = 0, &cj = ci;
decltype(ci) x = 0;         // x has type const int
decltype(cj) y = x;         // y has type const int& and is bound to x
decltype(cj) z;             // error: z is a reference and must be initialized
```

Because `cj` is a reference, `decltype(cj)` is a reference type. Like any other reference, z must be initialized.

**It is worth noting that `decltype` is the only context in which a variable defined as a reference is not treated as a synonym for the object to which it refers.**

>在 decltype 中 reference 不作为 reference 的本意解释，并不代表 reference 实际代表的值。
