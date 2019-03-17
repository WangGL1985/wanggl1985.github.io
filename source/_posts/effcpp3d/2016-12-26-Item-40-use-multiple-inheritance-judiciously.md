---
title: 『Effective C++ 读书笔记40』 use multiple inheritance judiciously
date: 2016-07-20 21:22:54
tags:
  - cpp
---

当出现多重继承时，程序有可能从一个以上的 base classes 继承相同名称。将会导致较多的歧义。

```cpp
class BorrowableItem{
public:
  void checkOut();
  ...
};

class ElectronicGadget{
private:
  bool checkOut() const;
  ...
};

class MP3Player:
  public BorrowableItem,
  public ElectronicGadget
  {
    ...
  };
  MP3Player mp;
  mp.checkOut();
```
此处会出现歧义，正确的做法是 `mp.BorrowableItem::checkOut()`。
```cpp
class IPerson{
public:
  virtual ~IPerson();
  virtual std::string name() const = 0;
  virtual std::string birthDate() const =0;
};
```
使用工厂函数将『派生自 IPersion 的具象 classes』实体化：
```cpp
std::tr1::shared_ptr<IPerson> makePerson(DatabaseID personIdentifier);
DatabaseID askUserForDatabaseID();
DatabaseID id(askUserForDatabaseID());
std::tr1::shared_ptr<IPerson> pp(makePerson(id));
```

---

- 多重继承比单一继承复杂。它可能导致新的歧义性，以及对虚函数继承的需要
-  virtual 继承会增加大小、速度、初始化复杂度等等成本。如果虚基类不带任何数据，将是最具实用价值的情况
- 多重继承的确有正当用途。其中一个情节涉及『public 继承某个 Interface class』和 『private 继承某个协议实现的 class』的两相组合。
