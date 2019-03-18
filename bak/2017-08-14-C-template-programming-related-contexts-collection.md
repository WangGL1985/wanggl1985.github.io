---
title: C++ template programming related contexts collection
date: 2017-08-14 16:10:57
tags:
  - 泛型编程
---

- mc++ primer: **Nontype Template Parameters**

> We can define templates that take nontype parameters. A nontype parameter represents a value rather than a type. Nontype parameters are specified by using a specific type name instead of the class or typename keyword.


> When the template is instantiated, nontype parameters are replaced with a value supplied by the user or deduced by the compiler. These values must be constant expressions, which allows the compiler to instantiate the templates during compile time.

```cpp
template <unsigned N, unsigned M>
int compare(const char (&p1)[N], const char (&p2)[M])
{
  return strcmp(p1,p2);
}

```

when we call this version of compare:

```cpp
compare("hi","mom");
```

A nontype parameter may be an integral type, or a pointer or reference to an object or to a function type. An argument bound to a nontype integral parameter must be a constant expression. Argument bound to a pointer or reference nontype parameter must have static lifetime.
