---
title: python __slots__
date: 2017-02-26 12:01:34
tags:
---
我就补充两点:

1.slot 限制的是实例的属性，而不是类的属性
如果要修改或是添加类的属性，完全不必定义什么函数
直接写:
Student.hobby = 'learn'
都可以达到修改的目的（大家可以试试）

同样，如果要修改实例的属性，那么即使依靠自定义函数也做不到的

2.如果在MythodType的例子中，填写类名。比如：

原代码是： s.set_age = MethodType(set_age, s)
如果改成： Student.set_age = MethodType(set_age, Student)
那么调用的时候，选择的调用名既可以是类名本身，也可以是任意一个实例名
比如：

Student.set_age(10)
s.set_age(20)
a.set_age(30)

而最后无论你输入的是什么,显示的结果肯定是最后一个（30）
print(a.age)
print(s.age)
print(Student.age)
都是统一的

结论：
所以，如果既要定义针对整个类(的所有实例)都适用的方法，又要避免方法是针对类而非实例这种情况的话

还是用廖老师后来的第二个方法:
Student.set_age = set_age

或者昨天前一节的setattr，我捣鼓了一下，也可以这样:
setattr(Student,'set_age',set_age)
这样就定义了一个名为同名的叫set_age，作用于Student中所有实例的方法
 Collapse


国风人已变
Created at 2天前, Last updated at 2天前
写得很好。张教主的第一题，其实添加的是类的属性，根本就没有绕过slots的限制。
 View Full Discuss    Reply This Topic

给类绑定方法的问题
auptxu created at 1-6 9:38, Last updated at 4天前
给class绑定方法后，所有实例均可调用：

>>> s.set_score(100)
>>> s.score
100
>>> s2.set_score(99)
>>> s2.score
99
>>> s.score
99
为什么 s.score 也变成99 了

Colin__阿哈
Created at 1-6 21:35, Last updated at 1-6 21:35
你这是在调用类方法set_age(),所以更改的是类的属性，而不是实例的属性

葡萄比芒果好吃
Created at 4天前, Last updated at 4天前
我测试是正确的

class Student(object):
    pass
def set_score(self, score):
    self.score = score
Student.set_score = set_score
s=Student()
s2=Student()
s.set_score(100)
s2.set_score(99)
print(s.score)
print(s2.score)
结果
100
99

葡萄比芒果好吃
Created at 4天前, Last updated at 4天前
但是使用MethodType给Class绑定方法，则是你的结果。可能这两种方式原理不同？
 View Full Discuss    Reply This Topic

好乱。。。
張-教-主 created at 2015-8-6 16:09, Last updated at 2-13 10:22
第一，slots只能限制添加属性，不能限制通过添加方法来添加属性：

def set_city(self, city):
    self.city=city

class Student(object):
    __slots__ = ('name', 'age', 'set_city')
    pass

Student.set_city = MethodType(set_city, Student)

a = Student()
a.set_city(Beijing)
a.city
上段代码中，Student类限制两个属性name 和 age，但可以通过添加方法添加一个city属性（甚至可以添加很多属性，只要set_city方法里有包括）

第二，属性分实例属性和类属性，多个实例同时更改类属性，值是最后更改的一个

def set_age(self,age):
    self.age=age

class Stu(object):
    pass

s=Stu()
a=Stu()

from types import MethodType

Stu.set_age=MethodType(set_age,Stu)

a.set_age(15) \\通过set_age方法，设置的类属性age的值
s.set_age(11) \\也是设置类属性age的值，并把上个值覆盖掉
print(s.age,a.age) \\由于a和s自身没有age属性，所以打印的是类属性age的值

a.age = 10  \\给实例a添加一个属性age并赋值为10
s.age = 20  \\给实例b添加一个属性age并赋值为20
\\这两个分别是实例a和s自身的属性，仅仅是与类属性age同名，并没有任何关系

print(s.age,a.age)  \\打印的是a和s自身的age属性值，不是类age属性值
所以，
1，slots并不能严格限制属性的添加，可通过在方法里定义限制之外的属性来添加本不能添加的属性（当然，前提是方法没有被限制）
2，类属性是公共属性，所有实例都可以引用的，前提是实例自身没有同名的属性，因此类属性不能随意更改（别的实例可能在引用类属性的值），就是说不能随便用a.set_age()更改age的值（因为调用此方法更改的是类属性age的值，不是实例a自身的age属性值）

各位大神，小弟理解哪里不对，请指正^_^~
 
