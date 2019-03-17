---
title: python oop
date: 2018-02-26 11:52:54
tags:
  python
---

# Python oop

## Instance variables


```Python
class Employee:
    pass

emp_1 = Employee()
emp_2 = Employee()

print(emp_1)
print(emp_2)

emp_1.first = 'guoliang'
emp_1.last = 'wang'
emp_1.email = 'guoliang.wang@company.com'
emp_1.pay = 50000

emp_2.first = 'yumiao'
emp_2.last = 'zhang'
emp_2.email = 'yumiao.zhang@company.com'
emp_2.pay = 60000

print(emp_1.email)
print(emp_2.email)
```

The output as below:

```bash
<__main__.Employee object at 0x10d6fb3c8>
<__main__.Employee object at 0x10d6fb438>
guoliang.wang@company.com
yumiao.zhang@company.com
```

从输出可知，emp_1 和 emp_2 是两个不同的实例变量，first, last, email, pay 都是实例特有的变量。

```python
class Employee:

    # self 表示实例本身
    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@company.com'

    def fullname(self):
        return '{} {}'.format(self.first, self.last)

```
初始化实例变量如下:
```python
emp_1 = Employee('guoliang', 'wang', 50000)
emp_2 = Employee('yumiao', 'zhang', 60000)
print(emp_1.email)
print(emp_2.email)
```

输出结果如下：

```bash
guoliang.wang@company.com
yumiao.zhang@company.com
```
运行如下代码：
```python
print(emp_1.fullname())
print(emp_2.fullname())
print(Employee.fullname(emp_1))
```
输出结果如下：
```bash
guoliang wang
yumiao zhang
guoliang wang
```

## Class variables

> 类变量分享所有的变量给实例
```python
class Employee:

    raise_amount = 1.05

    # self 表示实例本身
    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@company.com'

    def fullname(self):
        return '{} {}'.format(self.first, self.last)

    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amount)

emp_1 = Employee('guoliang', 'wang', 50000)
emp_2 = Employee('yumiao', 'zhang', 60000)
```

```python
print(emp_1.pay)
emp_1.apply_raise()
print(emp_1.pay)
```

```bash
50000
52500
```

```python
Employee.raise_amount = 1.06
print(Employee.raise_amount)
print(emp_1.raise_amount)
print(emp_2.raise_amount)
```

```python
1.06
1.06
1.06
```

```python
emp_1.raise_amount = 1.05
print(Employee.raise_amount)
print(emp_1.raise_amount)
print(emp_2.raise_amount)
```
```bash
1.06
1.05
1.06
```

```python
print(Employee.__dict__)
```

```bash
{'__module__': '__main__', 'raise_amount': 1.06, '__init__': <function Employee.__init__ at 0x10d70e8c8>, 'fullname': <function Employee.fullname at 0x10d70eb70>, 'apply_raise': <function Employee.apply_raise at 0x10d70eae8>, '__dict__': <attribute '__dict__' of 'Employee' objects>, '__weakref__': <attribute '__weakref__' of 'Employee' objects>, '__doc__': None}
```

```python
print(emp_1.__dict__)
print(emp_2.__dict__)
```

```bash
{'first': 'guoliang', 'last': 'wang', 'pay': 52500, 'email': 'guoliang.wang@company.com', 'raise_amount': 1.05}
{'first': 'yumiao', 'last': 'zhang', 'pay': 60000, 'email': 'yumiao.zhang@company.com'}
```

```python
class Employee:

    num_of_employee = 0

    def __init__(self):
        Employee.num_of_employee += 1


emp_1 = Employee()
emp_2 = Employee()

print(Employee.num_of_employee)
```
```bash
2
```

## classmethods and staticmethods


```python
class Employee:

    raise_amount = 1.05

    # self 表示实例本身
    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@company.com'

    def fullname(self):
        return '{} {}'.format(self.first, self.last)

    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amount)

    @classmethod
    def set_raise_amount(cls, amount):
        cls.raise_amount = 1.05

    @classmethod
    def from_string(cls, emp_str):
        first, last, pay = emp_str.split('-')
        return cls(first, last, pay)

    @staticmethod
    def is_workday(day):
        if day.weekday() == 5 or day.weekday() == 6:
            return False
        return True


emp_1 = Employee('guoliang', 'wang', 50000)
emp_2 = Employee('yumiao', 'zhang', 60000)


print(Employee.raise_amount)
print(emp_1.raise_amount)
print(emp_2.raise_amount)
```

```bash
1.05
1.05
1.05
```


```python
emp_str_1 = 'guoliang-wang-70000'
new_emp = Employee.from_string(emp_str_1)
print(new_emp.email)
```

```python
import datetime
my_datetime = datetime.date(2016,7,11)
print(Employee.is_workday(my_datetime))
```
## Inheritance

```python
class Employee:

    raise_amount = 1.10

    # self 表示实例本身
    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@company.com'

    def fullname(self):
        return '{} {}'.format(self.first, self.last)

    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amount)
```

```python
class Developer(Employee):
    def __init__(self,first,last,pay,prog_lang):
        super().__init__(first,last,pay)
        #Employee.__init__(self,first,last,pay)
        self.prog_lang = prog_lang

```
```python
dev_1 = Developer('guoliang', 'wang', 50000,'Python')
dev_2 = Developer('yumiao', 'zhang', 60000,'Java')
```


```python
print(dev_1.email)
print(dev_2.prog_lang)
```

```python
print(dev_1.pay)
dev_1.apply_raise()
print(dev_1.pay)
```

```python
class Manger(Employee):
    def __init__(self,first,last,pay,employees=None):
        super().__init__(first,last,pay)
        #Employee.__init__(self,first,last,pay)
        if employees is None:
            self.employees = []
        else:
            self.employees = employees

    def add_emp(self, emp):
        if emp not in self.employees:
            self.employees.append(emp)

    def remove_emp(self, emp):
        if emp not in self.employees:
            self.employees.remove(emp)

    def print_emps(self):
        for emp in self.employees:
            print('-->',emp.fullname())
```

```python
mgr_1 = Manger('Sue','Smith',90000,[dev_1])
print(mgr_1.print_emps())
mgr_1.add_emp(dev_2)
print(mgr_1.print_emps())
```

```python
print(isinstance(mgr_1, Manger))
print(issubclass(Developer, Employee))
```


## Magic methods(Dunder methods)


```python
class Employee:
    # self 表示实例本身
    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@company.com'

    def fullname(self):
        return '{} {}'.format(self.first, self.last)

    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amount)

    def __repr__(self): # used for debug
        return "Employee('{}', '{}', '{}')".format(self.first, self.last, self.pay)

    def __str__(self):
        return '{} - {}'.format(self.fullname(), self.email)
```
```python
emp_1 = Employee('guoliang', 'wang', 50000)
```

```python
print(emp_1)
```

```python
print(repr(emp_1))
```


```python
class Employee:
    # self 表示实例本身
    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay

    @property
    def email(self):
        return '{}.{}@company.com'.format(self.first, self.last)

    @property
    def fullname(self):
        return '{} {}'.format(self.first, self.last)

    @fullname.setter
    def fullname(self,name):
        first, last = name.split(' ')
        self.first = first
        self.last = last

    @fullname.deleter
    def fullname(self):
        print('Delete Name!')
        self.first = None
        self.last = None
```
```python
emp_1 = Employee('guoliang', 'wang', 50000)
print(emp_1.email)
print(emp_1.fullname)
```

```python
emp_1.fullname = 'mohan wang'
print(emp_1.fullname)
del emp_1.fullname
```
