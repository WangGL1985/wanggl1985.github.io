---
title: ' python 中 *args 和 **kwargs的使用'
date: 2017-08-22 20:43:44
tags:
  - python
---

python 中的 *args 和 **kwargs 用于函数参数的定义，以 C 语言中可变参数的函数类似。即函数定义者并不知道函数使用者会传递多少个参数。

<!-- more -->

### *args 是用来发送一个非键值对的可变数量的参数列表给一个函数。

```python
def test_var_args(f_arg, *arg):
  print("first normal arg:", f_arg)
  for arg in argv:
    print("another arg through *argv:",arg)

test_var_args("yasoob", "python","eggs","test")
```


### `**kwargs` 允许你将不定的键值对，作为参数传递给函数。

```python
def greet_me(**kwargs):
  for key, value in kwargs.items():
    print("{0} == {1}".format(key, value))


greet_me(name="yasoob")
```

### 使用 `*args` 和 `**kwargs` 调用函数

```python
def test_args_kwargs(arg1, arg2, arg3):
  print("arg1:", arg1)
  print("arg2:", arg2)
  print("arg3:", arg3)

args = ("two", 3, 5)
test_args_kwargs(*args)

kwargs = {"arg3" : 3, "arg2" : "two", "arg1": 5}
test_args_kwargs(**kwargs)
```
