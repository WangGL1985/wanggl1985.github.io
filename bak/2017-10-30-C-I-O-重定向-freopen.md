---
title: C I/O 重定向 freopen()
date: 2017-10-30 21:26:15
tags:
  - C
---

使用场景：在代码测试时，如果测试数据庞大，需要多次输入，这可以使用 `freopen` 函数。

<!-- more -->

### 函数格式

```c
FILE *freopen(const char * filename, const char * mode, FILE * stream);
```

### 函数功能

实现重定向，把预定义的标准流文件定向到由 `filename` 指定的文件中。主要作用是节省测试数据输入浪费时间。

### 代码块

```c
#ifdef TEST
  freopen("redirect_in.txt","r", stdin);
  freopen("redirect_out.txt","w", stdout);
#endif
```
