---
layout: post
title: 『Effective C++ 读书笔记9』 绝不在构造和析构过程中调用`virtual`函数（Never call virtual functions during construction or destruction）
date: 2016-05-02
tags:
	- cpp
---

**不能在构造函数和析构函数中调用『虚函数』，因为首先构造派生类中的基类成分，而此时在基类中的虚函数代表的是基类，因为派生类还没有构造**。分析代码:

<!-- more -->

```cpp
class Transaction{														// 所有交易的基类
public:
	Transaction();
	virtual void logTranaction() const = 0;			// 做出一份因类型不同而不同的日志记录
	...
};
Transaction::Transaction()
{
	...
	logTransaction();
}

class SellTransaction: public Transaction{
public:
	virtual void logTransaction() const;
	...
};

class BuyTransaction: public Transaction{
public:
	virtual void logTransaction() const;
	...
};

BuyTransaction b;
```

会有一个 `BuyTransaction` 构造函数被调用，但首先 `Transaction` 构造函数会更早的被调用；然而基类构造函数最后一行调用的 `logTransaction` 是基类的版本，此时对象的行为就像隶属于 `base` 一样。一句话总结就是： **在基类构造期间，虚函数不是虚函数**。

在派生类对象的基类构造期间，对象的类型是基类。对象在派生类构造函数开始执行之前不会成为一个派生类对象。对于析构函数：一旦派生类析构函数开始执行，对象内的派生类成员变量便呈现未定义值，所以 `C++`  使它们仿佛不存在。

```cpp
class Transaction{
public:
	Transaction()
	{
		init();
	}
	virtual void logTransaction() const = 0;
	...
private:
	void init()
	{
		...
		logTransaction();
	}
};
```
当纯虚函数被调用，大多执行系统会中止程序。然而如果 logTransaction 是个正常的虚函数并在 transaction 内带有一份实现代码，该版本会被调用，程序会继续执行，但是会在建立一个派生类时调用错误版本的 logTransaction.

避免上述问题的方式：**确定你的构造函数和析构函数都没有调用 `virtual` 函数，而它们调用的所有函数也都服从同一约束。**

解决方法：在 `class Transaction` 内将 `logTransaction` 函数改为`non-virtual`，然后要求派生类传递必要信息给 `Transaction` 构造函数。

```cpp
class Transaction{
public:
	explicit Transaction(const std::string& logInfo);
	void logTransaction(const std::string& logInfo) const;

	...
};

Transaction::Transaction(const std::string& logInfo)
{
	...
	logTransaction(logInfo);
}

class BuyTransaction:: public Transaction{
public:
	BuyTransaction(parameters)
	:Transaction(createLogString(parameters))
	{
		...
	}
	...
private:
	static std::string createLogString( parameters );
};
```
**比起在成员初值列内给基类所需数据，利用辅助函数创建一个值传递给基类构造函数往往比较方便。**令此函数为 static 也就不可能意外指向『初期未成熟之 BuyTransaction 对象内尚未初始化的成员变量』。

**由于你无法使用虚函数从基类向下调用，在构造期间，你可以籍由『令派生类将必要的构造信息向上传递至基类构造函数』替换之而加以弥补**。

---

-	在构造和析构期间不要调用虚函数，因为这类调用从不下降至派生类
