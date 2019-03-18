---
title: Machine Learning Fundation 第三讲学习笔记
date: 2017-03-18 15:00:09
tags:
  - ml
---


<!-- more -->
## 从输出空间出发

### 输出空间 Y 为 yes/no

当输出空间是二选一时，称为二元分类(`Binary Classication`)，典型的例子有前文提到的信用卡核发问题。
<!-- more -->

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-070904.jpg)

更多的二元分类例子

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-070947.jpg)

### 输出空间为多选一

当输出空间 Y 为多选一时，称为多元分类（`Multiclass Classification`）。即可以将分类问题推广到多类，例如自动贩卖机按货币面值大小分类问题。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-071639.jpg)

### 输出空间为一个实数

当输出空间 Y 为一个实数时，称为回归问题(`Regreeion`)，例如估计相关问题的期限等问题。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-072100.jpg)

### 输出空间为结构序列

当输出空间为结构序列时，称为结构分类（`Structure Learning`）.比如自然语言中一个句子词性分析。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-072728.jpg)

结构学习是一个超类问题，类似与多个多元分类问题的组合。

从输出空间的角度看，机器学习主要包含二元分类、多元分类、回归问题和结构学习等。
以学校体育馆门禁系统人脸识别系统为例，输出 Y 分为四类：工作人员、学生、教师及其他。那么这个示例属于哪种分类问题呢，因为 Y 有明确的输出分类，且为多个，所以属于多元分类问题。

## 从输入的角度看机器学习

### 监督式学习

从输入的数据 X<sub/>n</sub>对应于输出 Y<sub/>n</sub> ，这种称为监督学习(`Supervised Learning`)。
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-075142.jpg)


### 非监督式学习

在训练自动贩卖机认识钱币时，钱币的相关特征有重量、大小、图案等，机器通过自己观察发现相应特征并依据特征将钱币分类，这就是非监督学习。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-075715.jpg)

其他非监督学习的例子：

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-075847.jpg)

常见的非监督学习有密度分析、异常检测等，其特点是目标非常分散、性能较难估计。

### 半监督学习

该方法结合了监督和非监督的优点，可以降低检测成本，弥补样本难以获得的问题。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-080506.jpg)

### 强化学习

奖励或惩罚的方式来告诉系统输出是否是你想要的，没有进行严格的规定，在可能的输出中选择可接受的。


![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-080857.jpg)


## 训练集角度

一次性将数据全部输入给机器，称为(`Batching Learning`)。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-081432.jpg)
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-081413.jpg)


当输入数据具有线性时间属性时，我们不可能一次性输入所有的数据。实际是不断的输入数据，并进行学习，这种系统称为在线学习系统(`Online Learning`)。


![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-081848.jpg)

当数据的前期处理成本太高，让机器有主动意识，当有不确定的学习实例出现时，机器主动的向人类提出问题。这类问题称为主动学习。


![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-082202.jpg)
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-082231.jpg)

## 训练集特性

### 具体特性

如果训练集中的数据的特征非常明确，这种数据通常是人为的预先将数据进行了处理。
![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-082926.jpg)

### 原始特性

机器学习的数据没有经过认为的处理，这就叫原始特征(`Raq Feature`)，比如声音信号的频率、图片的像素等。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-083230.jpg)

如果训练集没有明显的特征可以提取，只能通过抽象来提取特征，这类问题称为抽象问题。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-083453.jpg)


![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-18-083522.jpg)
