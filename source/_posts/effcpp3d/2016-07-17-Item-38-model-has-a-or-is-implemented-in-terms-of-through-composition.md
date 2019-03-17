---
title: 『Effective C++ 读书笔记38』 通过复合塑模出 has-a 或根据某物实现出
date: 2016-07-17 11:13:27
tags:
  - cpp
---

复合（ `composition` ）是类型之间的一种关系，当某种类型的对象内含它种类型的对象,便是复合关系。

<!-- more -->
```cpp
class Address{...};
class PhoneNumber { ... };
class Person {
public:
  ...
private:
  std::string name;
  Address address;
  PhoneNumber voiceNumber;
  PhoneNumber faxNumber;
};

```
复合术语的同义词有分层、内含、聚合、内嵌。复合意味着 `has-a` 或 `is-implemented-in-terms-of`（根据某物实现出）。因为你正打算在你的软件中处理两个不同的领域。当复合发生于应用域内的对象之间，表现出 `has-a` 的关系；当它发生于实现域内则是表现 `is-implemented-in-terms-of` 的关系。

区分 `is-a` 和 `is-implemented-in-terms-of`，如果继承自 list 来实现 set，存在的问题时 set 不能有重复的元素，然而 list 可以，不满足 has-a 的关系。

```cpp
template <typename T>
class Set {
public:
  bool member(const T& item) const;
  void insert(const T& iterm);
  void remove(const T& item);
  std::size_t size() const;
private:
  std::list<T> rep;
};
```


---

- 复合的意义和 `public` 继承完全不同
- 在应用域，复合意味 `has-a`。在实现域，复合意味 `is-implemented-in-terms-of`。
