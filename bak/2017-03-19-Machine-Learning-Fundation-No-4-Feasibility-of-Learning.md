---
title: Machine Learning Fundation No.4 Feasibility of Learning
date: 2017-03-19 17:23:01
tags:
  - ml
---

教授在本节中讨论机器学习的可能性，从已知的信息出发，推测出 g，在已知的数据集合中，g 和 f 是近似的。但能不能就说在 D 以外的部分 g 和 f 是否任然保持近似。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-19-093744.jpg)

从 D 出发，观察 x 的特点，观察序列中 1 的奇偶性，是一种可能的 g。但 D 以外的部分是否满足这样的特征呢？

## 以罐子中弹珠的例子说明

一个罐子中有很多橘色和绿色的弹珠，如何推测出橘色弹珠出现的概率。首先，从罐子中取样，从取出的样品计算橘色弹珠的比例，假设为 u，那么能否说罐子中橘色弹珠的比例为 u 呢？

### Hoeffding's Inequality

该定理说明当 N 很大时，存在一个数 e，使得真实的概率 v 与预测概率 u 的差值大于 e，即 v-u > e，其概率如下：

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-19-101719.jpg)

说明当 N 很大时，v 和 u 将非常接近。所以当 N 很大时，可以通过 u 来推测 v。

### 应用到机器学习

对比两种问题的已知和未知情况：

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-19-102129.jpg)

对于一个固定的 h(x)，验证其在已知资料中的表现情况，当 D 足够大时，就可以推测 h(x) 与 f(x) 可能有相同的概率。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-19-103122.jpg)

取得一部分数据作为 traning examples，使用 h（x）得到 y<sub/>n</sub>。

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-19-103355.jpg)

### 验证 H(X) 好不好

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-19-103611.jpg)

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-19-105544.jpg)

![](http://olkbjcb09.bkt.clouddn.com/blog/2017-03-19-105626.jpg)
