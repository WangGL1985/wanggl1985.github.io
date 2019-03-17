---
layout: post
title:  『Effective C++ 读书笔记11』 在 operator= 中处理『自我赋值』
date: 2016-05-04
tags:
	- cpp
---

『自我赋值』发生在对象赋值给自己时；通常潜在的自我赋值是由『别名』引起的，『别名』是指『有一个以上的方法指称某对象』。

```cpp
class Base{};
class Derived: public Base{};
void doSomething(const Base& rb, Derived* pd);  // rb and pd maybe point to the same object
```
<!-- more -->
当你进行资源的管理时，可能会出现在停止使用资源之前意外释放了它。假设建立了一个 `class` 用来保存一个指针指向一块动态分配的位图。

```cpp
class Bitmap{};
class Widget{
	...
private:
	Bitmap* pb;
};

Widget&
Widget::operator=(const Widget& rhs)
{
	delete pb;
	pb = new Bitmap(*rhs.pb);
	return *this;
}
```

上段代码中，如果出现自我赋值，显然会出现问题。传统做法是在 `operator=` 最前面加一个『证同测试』。

```cpp
Widget&
Widget::operator=(const Widget& rhs)
{
	if(this == &rhs) return *this;

	...
}
```

但是，这段代码仍然存在异常方面的麻烦。我们需要注意的是在复制 `pb` 所指东西之前别删除 `pb`。

```cpp
Widget& Widget::operator=(const Widget& rhs)
{
	Bitmap* pOrig = pb;
	pb = new Bitmap(*rhs.pb);
	delete pOrig;
	return *this;
}
```

简单的测试代码如下：

```cpp
class Bitmap{};


class Widget{

    public:
        Widget& operator=(const Widget& rhs);
    private:
        Bitmap* pb;
};

    Widget&
Widget::operator=(const Widget& rhs)
{
    if(this == &rhs)
        return *this;
    // 防止 new Bitmap 时出错
    Bitmap* pOrig = pb;
    pb = new Bitmap(*rhs.pb);
    delete pOrig;
    return *this;
}


int main()
{
    Widget tst;

    tst = tst;
    return 0;
}
```
在 `operator=` 函数内手工排序语句的一个替代方案 -- 使用 `copy and swap` 技术。
```cpp
class Widget{
	...
	void swap(Widget& rhs);
	...
};

Widget& Widget::operator=(const Widget& rhs)
{
	Widget temp(rhs); 													// crate copy item
	swap(temp);    															// swap this and rhs
	return *this;
}
```

---

-	确保当对象自我赋值时 `operator=` 有良好行为。其中技术包括比较『来源对象』和『目标对象』的地址、精心周到(异常安全)的语句顺序、以及 `copy-and-swap`
-	确定任何函数如果操作一个以上的对象，而其中多个对象是同一个对象时，其行为仍然正确。
