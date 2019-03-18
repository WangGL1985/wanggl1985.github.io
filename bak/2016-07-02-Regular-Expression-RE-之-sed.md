---
title: Regular Expression(RE) 之 sed
date: 2016-07-02 10:38:24
tags:
---

关于 `sed`，有人这么说[^1]：

> Sed is the ultimate **s**tream **ed**itor. If that sounds strange, picture a stream flowing through a pipe. Okay, you can't see a stream if it's inside a pipe. That's what I get for attempting a flowing analogy. You want literature, read James Joyce.

<!-- more -->
# `sed` 命令

命令	| 功能
---|---
a\\	|在当前行后添加一行或多行。多行时除最后一行外，每行末尾需用“\”续行

c\\	 |用此符号后的新文本替换当前行中的文本。多行时除最后一行外，每行末尾需用"\"续行
i\\	 |在当前行之前插入文本。多行时除最后一行外，每行末尾需用"\"续行
d	| 删除行
h	 |把模式空间里的内容复制到暂存缓冲区
H	 |把模式空间里的内容追加到暂存缓冲区
g	 |把暂存缓冲区里的内容复制到模式空间，覆盖原有的内容
G	 |把暂存缓冲区的内容追加到模式空间里，追加在原有内容的后面
l	 |列出非打印字符
p	 |打印行
n	 |读入下一输入行，并从下一条命令而不是第一条命令开始对其的处理
q	 |结束或退出sed
r	 |从文件中读取输入行
!	 |对所选行以外的所有行应用命令
s	 |用一个字符串替换另一个
g	 |在行内进行全局替换
w	 |将所选的行写入文件
x	 |交换暂存缓冲区与模式空间的内容
y	 |将字符替换为另一字符（不能对正则表达式使用y命令）

# `sed` 选项


 选项	| 功能
 ---|---
 e	 |进行多项编辑，即对输入行应用多条 `sed` 命令时使用
 -n	 |取消默认的输出
 -f	 |指定 `sed` 脚本的文件名

# 正则表达式元字符

元字符	| 功能	| 示例
---|---|---
^	 |行首定位符	| /^my/  匹配所有以my开头的行
$	 |行尾定位符	 |/my$/  匹配所有以my结尾的行
.	 |匹配除换行符以外的单个字符	| /m..y/  匹配包含字母m，后跟两个任意字符，再跟字母y的行
*	 |匹配零个或多个前导字符	| /my*/  匹配包含字母m,后跟零个或多个y字母的行
[]	| 匹配指定字符组内的任一字符	 |/[Mm]y/  匹配包含My或my的行
[^]	| 匹配不在指定字符组内的任一字符	| /[^Mm]y/  匹配包含y，但y之前的那个字符不是M或m的行
\(..\)|	 保存已匹配的字符	| 1,20s/\(you\)self/\1r/  标记元字符之间的模式，并将其保存为标签1，之后可以使用\1来引用它。最多可以定义9个标签，从左边开始编号，最左边的是第一个。此例中，对第1到第20行进行处理，you被保存为标签1，如果发现youself，则替换为your。
&	| 保存查找串以便在替换串中引用	| s/my/**&**/  符号&代表查找串。my将被替换为**my**
\<|	 词首定位符|	 /\<my/  匹配包含以my开头的单词的行
\>	| 词尾定位符	| /my\>/  匹配包含以my结尾的单词的行
x\{m\}	| 连续m个x	| /9\{5\}/ 匹配包含连续5个9的行
x\{m,\}	| 至少m个x	 |/9\{5,\}/  匹配包含至少连续5个9的行
x\{m,n\}|	 至少m个，但不超过n个x	| /9\{5,7\}/  匹配包含连续5到7个9的行

# 怎么理解 `s`

> s is substitute

使用 `sed` 命令的时候，一个好的习惯是将 `sed` 后的动作用 `'` 包起来，切记！

```
echo day | sed 's/day/night'
```
以一个例子来分析

> sed 's/one/ONE/' <file

- `s` --> 替换命令
- `/../../`--> 定义符号
- `one` --> 待搜索的模板
- `ONE` --> 替换内容

# 路径的表示方法

- `sed 's/\/usr\/local\/bin/\/common\/bin/' <old >new`
- `sed 's_/usr/local/bin_/common/bin_' <old >new`
- `sed 's:/usr/local/bin:/common/bin:' <old >new`
- `sed 's|/usr/local/bin|/common/bin|' <old >new`

也就是说 `sed` 支持这么多的分隔符，并且不同分隔符之间的『分辨率』不同。

# 用 `&` 代表匹配的字符串

> echo "123 abc" | sed 's/[0-9]*/&/'

```
123 abc
```
搜索到的匹配模板是 `123`， 但是 `abc` 是怎么回事呢？

> echo "123 abc" | sed 's/[0-9]*/& &/'

```
123 123 abc
```

> echo "123 abc" | sed 's/[0-9]*/& & &/'

```
123 123 123 abc
```
字符串 `abc` 没有变化，因为并没有在正则表达式匹配，如果要忽略掉正则表达式未匹配的部分，则可以用 `，` 或 `\1`。

# 使用 `\1` 保留部分匹配模板

> echo abcd123 | sed 's/\([a-z]*\).*/\1/'

```
abcd
```

> echo abc 1213 | sed 's/\([a-z]*\) \([0-9]*\)/\2 \1/'

```
1213 abc
```

> echo abc dsd | sed 's/\([a-z][a-z]*\) \([a-z][a-z]*\)/\2 \1/'

```
dsd abc
```
> echo a12 dff dsd | sed 's/\([a-z][a-z]*\) \([a-z][a-z]*\)/\2 \1 &/'

输出什么呢？

> echo abc eed | sed -E 's/([a-z]+) ([a-z]+)/\2 \1/'

`\1` 不需要在替换字符串的位置

> echo abc abc | sed 's/\([a-z]*\) \1/\1/'

```
abc
```
> echo abc abc | sed -n '/\([a-z][a-z]*\) \1/p'

```
abc abc
```
> echo abc abc | sed -En '/([a-z]+) \1/p'

# `sed` 中的匹配标志

- `/g` 全局替换

> echo dsfsd sdfsd | sed 's/[^ ][^ ]*/(test)/g'

```
(test) (test)
```

> echo loop loop loop | sed 's/loop/loop the loop/g'

# 以行为单位的新增/删除

> nl /etc/passwd | sed '2,5d'

```
➜  regular-expression nl /etc/passwd | sed '2,5d'
     1	##
     6	# Open Directory.
     7	#
     8	# See the opendirectoryd(8) man page for additional information about
     9	# Open Directory.
     ...
```
- `a` 是 `add` 意思
```
nl /etc/passwd | sed '2a drink tea'
nl /etc/passwd | sed '2i drink tea'
nl /etc/passwd | sed '2d'
nl /etc/passwd | sed '3,$d'
```
# `p` 命令

显示匹配空间的内容，默认清空下， `sed` 把输入行打印在屏幕上，选项 `-n` 用于取消默认的打印操作，当选项 `-n` 存在时，只打印选定的内容。

> echo this is a test | sed '/thi/p'
```
this is a test
this is a test
```
> echo this is a test | sed -n '/thi/p'
```
this is a test
```

# `d` 命令

> sed '$d' datafile
删除特定行
> sed '/my/d' datafile
删除包含 `my` 的行

# `s` 命令

> sed 's/^My/You/g' datafile

> sed -n '1,20s/My$/You/gp' datafile

> sed 's#My#Your#g' datafile

#紧跟在s命令后的字符就是查找串和替换串之间的分隔符。分隔符默认为正斜杠，但可以改变。无论什么字符（换行符、反斜线除外），只要紧跟s命令，就成了新的串分隔符。
加入两行字符

# `e` 选项

`-e` 是编辑命令，用于进行多重编辑，

> sed -e '1,10d' -e 's/My/Your/g' datafile
#选项 `-e` 用于进行多重编辑。第一重编辑删除第1-3行。第二重编辑将出现的所有 `My` 替换为 `Your`。因为是逐行进行这两项编辑（即这两个命令都在模式空间的当前行上执行），所以编辑命令的顺序会影响结果。

# `r` 命令

`r` 命令是读命令。`sed` 使用该命令将一个文本文件中的内容加到当前文件的特定位置上。

> sed '/My/r introduce.txt' datafile

# `w` 命令

> sed -n '/I/w me.txt' regular_express.txt
将 `regular_express.txt` 中 `I` 的行写到 `me.txt` 文件。
> cat me.txt

```
I can't finish the test.
I like dog.
# I am VBird
```
# `a\` 命令

`a\` 命令是追加命令，追加将添加新文本到文件中当前行（即读入模式缓冲区中的行）的后面。所追加的文本行位于 `sed` 命令的下方另起一行。如果要追加的内容超过一行，则每一行都必须以反斜线结束，最后一行除外。最后一行将以引号和文件名结束。

```
➜  shell echo test > datefile
➜  shell cat datefile
test
```

```
sed '/^test/a\
>hrwang and mjfan are husband\
>and wife' datafile
```
如果在 `datafile` 文件中发现匹配以 `test` 开头的行，则在该行下面追加 `hrwang and mjfan are husband and wife`

# `i\` 命令

```
sed '/^test/i\
>hrwang and mjfan are husband\
>and wife' datefile
```
```
>hrwang and mjfan are husband
>and wifetest
```
# `c\` 命令

将已有文本修改成新的文本

# `n` 命令

`sed` 使用该命令获取输入文件的下一行，并将其读入到模式缓冲区中，任何 `sed` 命令都将应用到匹配行紧接着的下一行上。
> sed '/hrwang/{n;s/My/Your/;}' datafile
注：如果需要使用多条命令，或者需要在某个地址范围内嵌套地址，就必须用花括号将命令括起来，每行只写一条命令，或这用分号分割同一行中的多条命令。

# `y` 命令

该命令与 `UNIX/Linux` 中的 `tr` 命令类似，字符按照一对一的方式从左到右进行转换。例如，`y/abc/ABC/` 将把所有小写的 `a` 转换成 `A`，小写的 `b` 转换成 `B`，小写的 `c` 转换成 `C`。

> sed '1,20y/hrwang12/HRWANG^$/' datafile

将1到20行内，所有的小写 `hrwang` 转换成大写，将1转换成 `^`,将2转换成 `$`。正则表达式元字符对 `y` 命令不起作用。与 `s` 命令的分隔符一样，斜线可以被替换成其它的字符。

# `q` 命令

`q` 命令将导致 `sed` 程序退出，不再进行其它的处理。

> sed '/hrwang/{s/hrwang/HRWANG/;q;}' datafile

# `h` 命令和 `g` 命令

```
#cat datefile
My name is hrwang.
Your name is mjfan.
hrwang is mjfan's husband.
mjfan is hrwang's wife.
```
> sed -e '/hrwang/h' -e '$G' datafile

```
My name is hrwang.
Your name is mjfan.
hrwang is mjfan's husband.
mjfan is hrwang's wife.
mjfan is hrwang's wife.
```
> sed -e '/hrwang/H' -e '$G' datefile

```
My name is hrwang.
Your name is mjfan.
hrwang is mjfan's husband.
mjfan is hrwang's wife.

My name is hrwang.
hrwang is mjfan's husband.
mjfan is hrwang's wife.
```
通过上面两条命令，你会发现 `h` 会把原来暂存缓冲区的内容清除，只保存最近一次执行 `h` 时保存进去的模式空间的内容。而 `H` 命令则把每次匹配 `hrwnag` 的行都追加保存在暂存缓冲区。

> sed -e '/hrwang/H' -e '$g' datefile

```
My name is hrwang.
Your name is mjfan.
hrwang is mjfan's husband.

My name is hrwang.
hrwang is mjfan's husband.
mjfan is hrwang's wife.
```

> sed -e '/hrwang/H' -e '$G' datefile

```
My name is hrwang.
Your name is mjfan.
hrwang is mjfan's husband.
mjfan is hrwang's wife.

My name is hrwang.
hrwang is mjfan's husband.
mjfan is hrwang's wife.
```
通过上面两条命令，你会发现 `g` 把暂存缓冲区中的内容替换掉了模式空间中当前行的内容，此处即替换了最后一行。而 `G` 命令则把暂存缓冲区的内容追加到了模式空间的当前行后。此处即追加到了末尾。

# 练习

> sed -e 's/^[a−z]{2,3}[0−9]:.*$/\1/'
```
echo bge0: flags=1000843<UP,BROADCAST,RUNNING,MULTICAST,IPv4> mtu 1500 index 2 | sed -e 's/^[a−z]{2,3}[0−9]:.*$/\1/'
```
> G	| 把**暂存缓**冲区的内容追加到模式空间里，追加在原有内容的后面

```
sed 'G;G' test.txt
```
> n	|读入下一输入行(偶数行)，并从下一条命令而不是第一条命令开始对其的处理；即用『下一条』命令处理读入行
```
 sed 'n;d' test.txt
```
删除偶数行

```
sed '/regex/{x;p;x;}' test.txt
```
> x	| 交换暂存缓冲区与模式空间的内容;  p | 打印行
上述命令中，第一个 `x` 的作用是用空行交换符合提取到的行， `p` 打印， 第二个 `x` 将内容换回来。 **在匹配式样“regex”的行之前插入一空行**

```
sed '/regex/G' test.txt
```
给符合模式空间的行追加一个空行
```
sed '/regex/{x;p;x;G;}'
sed = filename | sed 'N;s/\n/\t/'
sed = filename | sed 'N; s/^/ /; s/ *.{6,}\n/\1 /'
sed '/./=' filename | sed '/./N; s/\n/ /'
sed -n '$='
```

sed 's/^$/d;G'
