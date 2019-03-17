---
title: smarter pointer in C++
date: 2018-03-06 10:27:54
tags:
  - daily
---

There are 3 ways for an object to go out of the scope:
  - encountering the next closing bracket
  - encountering a return statement
  - having an exception throw inside the current scope that is not caught inside the current scope.


RAII:


- std::unique_ptr
- raw pointer
- std::shared_ptr
- std::weak_ptr
- boost::scoped_ptr
- std::auto_ptr

unique_ptr cannot be copied, the ownership can however be transferred from one unique_ptr to another by moving a unique_ptr into another one.


raw pointer

raw pointers and references represent access to an object, but not ownership.



shared_ptr

A single memory resource can be held by several std::shared_ptrs at the same time.


weak_ptr

break shared_ptr circular references.


scoped_ptr

not in standard.


auto_ptr

removed from C++17
