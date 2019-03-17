---
title: 『Effective C++ 读书笔记29』 为『异常安全』而努力是值得的
date: 2016-07-09 13:50:59
tags:
  - cpp
---

假设有个 `class` 用来表现夹带背景图案的 `GUI` 菜单，这个 `class` 希望用于多线程环境，所以它有个互斥器作为并发控制之用。

<!-- more -->
```cpp
class PrettyMenu {
public:
  ...
  void changeBackground(std::istream& imgSrc) {
    /* code */
  }
private:
  Mutex mutex;
  Image* bgImage;
  int imageChanges;
};
```
changeBackground 的一种可能的实现
```cpp
void PrettyMenu::changeBackground(std::istream imgSrc) {
  lock(&mutex);
  delete bgImage;
  ++imageChanges;
  bgImage = new Image(imgSrc);
  unlock(&mutex);
}
```
从异常安全的角度来看，这个函数很糟。异常安全的两个条件都没有满足。

- 不泄露任何资源， `new Image(imgSrc)`导致异常，则 `unlock`永远不会被执行
- 不允许数据败坏，一旦 `new Image（imgSrc）`抛出异常， `bgImage` 就是指向一个已被删除的对象

条款 14 导入了 `Lock class` 作为一种 『确保互斥器被及时释放』的方法
```cpp
void PrettyMenu::changeBackground(std::istream& imgSrc) {
  Lock ml(&mutex );
  delete bgImage;
  ++imageChanges;
  bgImage = new Image(imgSrc);
}
```

异常安全函数的基本保证

- 基本承诺，如果异常被抛出，程序内的任何事物仍然保持有效状态。
- 强烈保证，如果异常被抛出，程序状态不改变。如果调用成功，就是完全成功，如果函数失败，程序会恢复到『调用函数之前』的状态。
- 不抛掷保证，承诺绝不抛出异常，因为它们总是能够完成它们原先承诺的功能。作用于内置类型身上的所有操作都提供 `nothrow` 保证。

```cpp
class PrettyMenu {
public:

  void changeBackground(std::istream& imgSrc) {
  }
private:
  Mutex mutex;
  std::shared_ptr<Image> bgImage;
  int imageChanges;
};
```
changeBackground 的一种改进的实现

```cpp
void PrettyMenu::changeBackground(std::istream imgSrc) {
  Lock ml(&mutex);
  bgImage.reset(new Image(imgSrc))
  ++imageChanges;
}
```


```cpp
struct PMImpl
{
  std::shared_ptr<Image> bgImage;
  int imageChanges;
};
class PrettyMenu
{
private:
  Mutex mutex;
  std::shared_ptr<PMImpl> pImpl;
};

void PrettyMenu::changeBackground(std::istream& imgSrc)
{
  using std::swap;
  Lock ml(&mutex);
  std::shared_ptr<PMImpl> pNew(new PMImpl(*pImpl));

  pNew->bgImage.reset(new Image(imgSrc));
  ++pNew->imageChanges;

  swap(pImpl, pNew);
}
```























---

- 异常安全函数即使发生异常也不会泄露资源或允许任何数据结果败坏。这样的函数区分分为三种可能的保证：基本型、强类型、不抛异常型
- 『强烈保证』往往能够以 `copy-and-swap` 实现出来
- 异常安全保障为串联模式
