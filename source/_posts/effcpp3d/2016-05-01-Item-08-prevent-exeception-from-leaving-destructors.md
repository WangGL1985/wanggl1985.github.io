---
layout: post
title: 『Effective C++ 读书笔记7』 别让异常逃离析构函数（Prevent exceptions from leaving destructors）
date: 2016-05-01
tags:
	- cpp
---

**`C++` 并不禁止析构函数吐出异常，但不鼓励这么做**.

<!-- more -->

分析以下代码：

```cpp
class Widget{
public:
	...
	~Widget() { ... }
};

void doSomething()
{
	std::vector<Widget> v;
	...
}
```
假设 `v` 中含有多个 `Widget`,析构第一个时抛出一个异常。但是其他的 `Widget` 还是应该被销毁，第二次析构又抛出一个异常，那么现在同时存在两个异常，这会导致程序结束或产生不明确行为。如果你的析构函数必须执行一个动作，而该动作可能在失败时抛出异常，后果可能是灾难性的。


```cpp
class DBConnection{
public:
	...
	static DBConnection create();


	void close();
};
```
假设使用一个类负责数据库连接：为了让客户不忘记在 `DBConnection` 对象身上调用 `close()`,创建一个用来管理 `DBConnection` 资源的 `class`，并在其析构函数中调用 `close`。

```cpp
class DBConn{
public:
	...
	~DBConn()
	{
		db.close();
	}
private:
	DBConnection db;
};
```
这便允许客户写出这样的代码：

```cpp
{
	DBConn dbc(DBConnection::create());
	...
}
```

如果调用 `close` 时出现异常，`DBConn` 析构函数会传播该异常，导致不明确的行为。解决方法有两个：

- 如果 `close` 抛出异常就结束程序。

```cpp
DBConn::~DBConn()
{
	try{ db.close();}
	catch( ... ){
		...
		std::abort();
	}
}
```
- 吞下异常

```cpp
DBConn::~DBConn()
{
	try{ db.close();}
	catch(...){
		...
	}
}
```

这些办法都没什么吸引力。问题在于两者都无法对『导致 `close` 抛出异常』的情况做出反应。一个较佳的策略是重新设计 `DBConn` 接口，使客户有机会对可能出现的问题做出反应。

```cpp
class DBConn{
public:
	...
	void close()
	{
		db.close();
		closed = true;
	}
	~DBConn()
	{
		if(!closed){
			try{
				db.close();
			}
			catch(...){
				...
			}
	}
private:
	DBConnection db;
	bool closed;
};
```
**把调用 `close` 的责任从 `DBConn` 析构函数上移到 `DBConn` 客户手上。有客户调用 `close`，给客户提供一个处理错误的机会。**如果某个操作可能在失败时抛出异常，而又存在某种需要必须处理该异常，那么这个异常必须来自析构函数以外的某个函数。


---

-	析构函数绝对不要吐出异常。如果一个被析构函数调用的函数有可能抛出异常，析构函数就应该捕获任何异常，然后吞下它们（不传播）或结束程序(abort)。
-	如果客户要求对某个操作函数运行期间抛出的异常做出反应，那么 `class` 应该提供一个普通函数（而非在析构函数中，双保险）执行该操作。
