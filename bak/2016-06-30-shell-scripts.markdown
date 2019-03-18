---
layout: post
title: Shell scripts
date: '2016-06-30 14:49'
tags:
  - 写给自己看的教程
---


`shell scripts` 是利用 `shell` 的功能写的一个『程序』，程序使用纯文本，将一些 `shell` 的语法与指令写在里面，搭配正则表达式、管道命令、数据重定向等。简单说就是汇集了一些需要执行的指令序列，使其能够以 `one touch` 的方式执行。

<!-- more -->
# 写前请注意

1. 指令的执行是从上而下、从左而右的分析和执行
2. 指令、选项与参数间的多个空白都会被忽略掉
3. 空白行被忽略， `tab` 键视为空格
4. 读到 `enter`， 则开始执行改行命令
5. `\[enter]` 续接命令
6. `#` 为批注

## 第一个 `「scripts」`

```bash
#!/bin/bash
echo "Hello World!\a \n"
exit 0
```
### 好的 `shell script` 撰写习惯

在每一个 `shell scripts` 文件中写明如下信息：

```bash
Function: function
Version:  version v0.1
Author:   Guoliang Wang
Email:    tswanggl@gmail.com
History:  history
Date:     20160630
Others:   no
```
在比较特殊的指令部分加上注释，使用版本控制工具管理你的脚本文件，比如 `git`、 `hg` 等

### 一些练习

1. 交互式脚本

命令关键字 `read`。

```bash
#!/bin/bash

read -p "Please input you first name:" filename
read -p "Please input you last name:" lastname
echo "\nYour full name is:" $firstname $lastname
```

2. 随日期变化建立文件
3. 简单计算

### 文件的执行方式

- `source`: 在程序中执行
- `sh scripts`
- `./script`

### 判断式

1. `test` 测试

`test` 只有有三种功能：『数值比较』、『字符串比较』、『文件比较』

  - 数值比较

  测试的标志 | 代表的含义
  :---:|:---:
  -eq| equal
  -ne| not equal
  -gt| grate to
  -lt| less to
  -ge| grate or equal
  -le| less or equal

```bash
#!/bin/bash

val1=`ehco "scale=4: 10/3" | bc`
echo "The test value is $val1"
if [ $val1 -gt 3 ];then
  echo "The result is larger then 3"
fi
```

  - 字符串比较

测试的标志 | 代表的含义
:---:|:---:
=| 字符串相同
!=| 是否不同
<| 小于
\>| 大于
-n| 长度是否为0
-z| 长度是否为0

```bash
#!/bin/bash

testuser=guolaing

if [ $USER = $testuser ];then
  echo "Welcome $testuser"
fi
```

```bash
#!/bin/bash

val1=Testing
val2=testing

if [ $val1 \> $val2 ];then
  echo "$val1 is greater than $val2"
else
  ehco "$val1 is less than $val2"
fi
```

  - 文件比较

测试的标志 | 代表的含义
:---:|:---:
-e| 存在？
-f| 文件？
-d| 目录？
-r| exsit && readable
-w| exsit && writable
-x| exsit && executable
-s| exsit && !empty
-nt|  new than
-ot|  old than
-O| owned by the effective user ID
-G| owned by the effective group ID

```bash
#!/bin/bash

if [ -d $HOME ];then
  echo "Your HOME directory exsits"
  cd $HOME
  ls -a
else
  echo "There is a problem with your HOME directory"
fi
```

```bash
#!/bin/bash

Function: function
Version:  version v0.1
Author:   Guoliang Wang
Email:    tswanggl@gmail.com
History:  history
Date:     20160630
Others:   no

echo "Please input a filename, I will check the filename's type and permission.\n\n"
read -p "Input a filename:" filename
test -z $fileanme && echo "You Musst input a filename." && exit 0
test -e $filename && echo "The filename '$filename' DO NOT exist" && exit 0
test -f $filename && filetype="regulare file"
test -d $filename && filetype="directory"
test -r $filename && perm="readable"
test -w $filename && perm="$parm writable"
test -x $filename && perm="$parm executable"

echo "The filename: $filename is $filetype"
echo "And the permissions are: $perm"
```
2. 利用判断符号 `[]`

> [ -z "$HOME" ];echo \$?

`[]` 作为判断式时两边需要加空格
> [ "$HOME" == "$MAIL" ]

- 在 `[]` 每个组件都需要空格键来分割
- `[]` 的变量用 `"` 括起来
- `[]` 内的常数用单或双引号括起来

```
name="VBird Tsai"
[ $name == "VBird" ] --> [ "$name" == "VBird" ]
```

```bash
#!/bin/bash

read -p "Please input (Y/N):"yn
[ "$yn" == "Y" -o "$yn" == "y" ] && echo "OK,continue" && exit 0
[ "$yn" == "N" -o "$yn" == "n" ] && echo "Oh,interrupt!" && exit 0
```
3. 复合测试条件

```bash
[ condition ] && [ condition2 ]
[ condition1 ] && [ condition2 ]
```

```bash
#!/bin/bash

if [ -d $HOME ] && [ -w $HOME/testing ]
then
  echo "The file exists and you can write to it"
else
  echo "I cannot write to the file"
fi
```

### `shell script` 的默认变量

- `$#` : 后接的参数个数
- `$@` : 代表『"$1" "$2" "$3" "$4"』
- `$*` : 代表『"$1"c"$2"c"$3"c"$4"』

```bash
#!/bin/bash

echo "The scripts name is   ==> $0"
ehco "Total parameter number is ===> $#"
[ "$#" -lt 2 ]&&echo "The number of parameter is less than 2. Stop here."&&exit 0
ehco "Your whole parameter is  ==> '$@'"
echo "The 1st parameter   ===>$!"
echo "The 2st parameter ===>$2"

```
`shift` 进行参数号码的偏移

## 条件判断式

## `if ... then`

- 单层、简单条件判断

```bash
if[条件判断式];then
  do something;
fi
```

or

```bash
if ...
then
  ......

fi
```

改写脚本

```bash
#!/bin/bash

if[ "$yn" == "Y" ] || [ "$yn" == "y" ];then
  echo "OK,continue"
  exit 0
fi
if[ "$yn" = "N" ]||[ "$yn" == "n" ];then
  echo "Oh,interrupt"
  exit 0
fi
```

- 多重、复杂判断

```bash
if[ ];then
  ...
else
  ...
fi
```
or

```bash
if[ ];then
  ...
elif[ ];then
  ...
else
  ...
fi
```
```bash
#!/bin/bash

read -p "Please input(Y/N):"yn

if[ "$yn" == "Y" ] || [ "$yn" == "n" ];then
  ehco "OK,continue"
elif[ "$yn" == "N" ]||[ "$yn" == "n" ];then
  else "Oh,interrupt"
else
  ehco "I don't know what your choice is"
fi
```
## `if...then` 高级特性

高级特性中支持的高级运算符
符号|描述
---|---
++val|
val--|
val++|
--val|
!|
~|
**|
<<|
>>|
&|
||
&&|
|||


- 数学表达式

```bash
#!/bin/bash

val1=10

if (( $val1 ** 2 > 90))
then
  ((val2 = $val1 ** 2))
  echo "The square of $val1 is $val2"
fi
```

- 高级字符串相关

```bash
#!/bin/bash

if [[ $USER ==r* ]]
then
  echo "Hello $USER"
else
  echo "Sorry, I do not know you"
fi
```

## 利用 `case ......esac`

```bash
case $1 in
"")
  ....
  ;;
"df")
  ...
  ;;
*)
  ...
esac
```
eg:

```bash
#!/bin/bash

case $USER in
rich | barbara)
  echo "Welcome. $USER"
  echo "Please enjoy your visit"
  ;;
testing)
  echo "Special testing account"
  ;;
jessica)
  echo "Do not forget to log off when you're done"
  ;;
*)
  echo "Sorry, you are not allowed here"
  ;;
esac
```

## function

```bash
function fname(){
  ...
}
```

## loop

### `while` 的基本形式

```bash
while[ condition ]
do
    ...
done
```
eg：

```bash
#!/bin/bash

var1=10
while [ $var1 -gt 0 ]
do
  echo $var1
  var1=$[ $var1 - 1 ]
done
```

or
```bash
until [ condition ]
do
    ....
done
```

 ### `for...do...done`

```bash
for var in con1 con2 con3
do
    ....
done
```
上述结构与 `c++` 中的 `for-each` 一样， 主要用于输出内容。

```bash
#!/bin/bash

for test in I don\'t know of "this'll" work
do
  echo "word: $test"
done
```
```bash
#!/bin/bash

for test in nevada "new hampshire" "new mexico" "new york"
do
  echo "Now going to $test"
done
```
```
#!/bin/bash

list="alabama alaska arizona colorado"
list=$list" connecticut"

...
```
### 从命令读取值

> for state in `cat filename`

### 更改字段分隔符

- 空格
- 制表符
- 换行符

```bash
IFS.OLD=$IFS
IFS=$'\n'
...
IFS=$IFS.OLD
```

### 用通配符读取目录

> for file on /home/*

## `C` 语言风格的 `for`

语法如下

```bash
for((init；limit;steps))
do
    ...
done
```
eg:

```
for (( i=1; i <= 10; i++))
do
  echo "the next number is $i"
done
```
![cstyle-for](/images/cstyle-for.png)

## 循环处理文件数据

```bash
#!/bin/bash

for entry in `cat /etc/passwd`
do
  echo "Value in $entry"
  IFS=:
  for value in $entry
  do
    ehco "    $value"
  done
done
```

## 循环控制语句

`break` 和 `continue`


# `shell scripts` 的追踪与 `debug`

可以使用 `bash` 的相关命令参数来进行 `shell scripts` `的 `debug`。

- `-n` ： 不执行脚本，只是检查语法问题
- `-v` ： 执行前先将 `scripts` 的内容输出至屏幕
- `-x` ： 将使用到的 `scripts` 的内容显示到屏幕上。『good』
