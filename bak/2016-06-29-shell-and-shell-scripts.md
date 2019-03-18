---
title: shell and shell scripts
date: 2016-06-29T13:50:39.000Z
tags:
  - 写给自己看的教程
---

在 `Linux` 中，每个人登入系统都能取得一个 `bash`，每一个 `shell` 中都有自己的变量。从用途来说，变量就是 **用一个简单的『字眼』来取代另一个比较复杂或者『容易变动的数据』**。

<!-- more -->
# 影响 `bash` 环境操作的变量

某些特定的变量会影响到 `bash` 的环境，比如 `PATH`，用户执行的每一条指令都是通过 `PATH` 中记录的路径顺序来查找指令的。如果 `PATH` 的路径中不存在，则会在终端显示 `command not found`. 提示信息。

## 变量的引用和设定

可以利用 `echo` 来打印变量的内容，语法为 `echo $varname` 或者 `echo ${varname}`。例如

```
echo $PATH
echo ${PATH}
```

变量的设定非常简单，用 `=` 连接变量和变量的内容就可以， **注意**： 设定变量时 `=` 两边不能有空格。

### 变量设定的规则

- 变量与变量内容用 `=` 连接
- `=` 两边直接接空格
- 变量名只能由数字和字母组成，且开头不能是数字
- 变量内容中有空格时，使用 `"` 或 `'` 将内容括起来
  - `var="lang is $LANG"`
  - `var='lang is $LANG'`
- 可用 `\` 实现转义
- 变量需要读取其他指令的执行结果时，需要将指令用『反单引号』或『$(command)』。
- 变量扩增的语法为， `PATH="$PATH":/home/bin` or `PATH=${PATH}:/home/bin` or `PATH=$PATH:/home/bin`
- `export` 将变量变成环境变量
- 自定义变量通常为小写
- 取消变量的方法为 `uset varname`

## 环境变量的功能

可以用命令 `env` 查看环境变量，用 `set` 命令显示所有变量。

- `PS1`
- `$`
- `？`
- `export` 将自定义变量转换为环境变量，语法为 `export varname`
- `locale -a`

## 变量的有效范围

环境变量可以被子程序使用，自定义变量只存在于当前 `shell`当中。

- 启动一个 `shell`， 系统分配内存给 `shell`
- `export` 的变量在子程序中可见
- 加载一个 `shell` 后，子 `shell` 可以将父 `shell` 的环境变量继承


## 变量读取，数组、宣告

以上提到的变量设定是在交互环境中直接设定的，可以用 `read` 命令在脚本中设定。

- read

`read` 命令读取来自键盘的输入信息，语法如下：
```
-p 后接提示字符
-t 后接等待的秒数
read -p "Please input your name:" -t 30 name
```

- declare/typeset

`declare` 和 `typeset` 的作用是『宣告变量』的类型。语法：

```
-a --> array
-i --> integer
-x --> ==export
-r --> set var to readonly can't unset
```

eg:

```
sum=100+200+400
echo $sum
declare -i sum=100+300+201
```


`bash` 默认变量类型为字符串类型， `bash` 环境中的数值运算为整数。

## 变量内容的删除、取代与替换

- 删除字符串， `#` 表示从前开始删除， `%` 表示从后面开始删除
  - `#` 区间内符合取代文字最短的
  - `##` 区间内符合取代文字最长的

eg:

```
echo ${path#/*kerberos/bin:}
echo ${path#/*:}
echo ${path##/*:}
echo ${path%/:*bin}
```

- 替换

```
${var/old/new}
${var//old/new}
```

## 变量的测试与内容替换

通过测试相关条件，如果满足条件就进行内容替换。

```
${username-root}
${username:root}
```

发量讴定方式 |str 没有讴定 |str 为空字符串 |str 已讴定非为空字符串
----|-----|-----|---
var=${str-expr} |var=expr |var=| var=$str
var=${str:-expr} |var=expr |var=expr |var=$str
var=${str+expr}| var= |var=expr| var=expr
var=${str:+expr} |var= |var= |var=expr
var=${str=expr} |str=expr var=expr |str 丌发 var= str 丌发 |var=$str
var=${str:=expr} |str=expr| var=expr |str=expr |var=expr str 丌发 var=$str
var=${str?expr} |expr 输出至 stderr |var= |var=$str
var=${str:?expr} |expr 输出至 stderr |expr 输出至 stderr |var=$str

```
unset st;var=${str-newvar}
str="oldvar";var=${str-newvar}
```

`-` 和 `=` 的区别

```
unset str;var=${str=newvar}
str="oldvar";var=${str=newvar}
```

仅仅测试是否存在

> unset str;var=${str?novar}

# 命令别名和历史命令

`alias` 和 `unalias`,主要是对一些使用频率较高且长的命令进行简化。

# history

`alias h='history'` 主要的参数有：

- `n` ：列出最近的 `n` 条命令
- `-c` 将目前的 `shell` 中的所有 `history` 内容全部消除
- `-a` 将目前新增的 `hisory` 指令新增入 `history` 中，没有的话预设写入 `~/.bash_history`
- `-r` 将 `histfiles` 的内容读到目前这个 `shell` 的 `history` 记忆中
- `-w` 将目前的 `history` 记忆内容写入 `histfile` 中

历史命令的读取和记录是这样的：

- 以 `bash` 登入 `Linux` 主机后，系统主动的由家目录的 `~/.bash_history`。
- 注销时将最近的 `HISTFILESIZE` 笔记录到记录文件当中
- `~/.bash_history` 记录由新的冲掉旧的

由 `history` 帮助执行命令

- `!number`
- `!command`
- !!

多个 `bash` 都以 `root` 身份登录，所有的记录都有自己的 `HISTSIZE` 笔记录在内存中，且等到注销时才会梗系记录文件。那么最后注销的那个 `bash` 才会是最后写入的数据。


# `bash` 的环境配置文件

如果要保留你的设定，需要将设定写入配置文件。

- `login` 与 `non-login shell`
  - `login shell`： 取得 `bash` 时需要完整的登入流程的，就称为 `login shell`。
  - `non-login shell` 取得 `bash` 接口的方法不需要重复登入
- `login shell` 需要读入的文件
  - `/etc/profile`： 系统设定文件，不建议修改
  - `~/.bash_profile` 或 `~/.bash_login` 或 `~/.profile`： 读取顺序由前到后
- `source` 读入环境配置文件的指令
- `~/.bashrc` (`non-login shell` 回读)


# 通配符与特殊符号

符号|意义
---|---
*|代表『 0 个刡无穷多个』任意字符
?|代表『一定有一个』任意字符
[]|同样代表『一定有一个在括号内』癿字符(非任意字符)。例如 [abcd] 代表『一定有一个字符, 可能是 a, b, c, d 这四个任何一个』
[-]|若有减号在中括号内时,代表『在编码顺序内癿所有字符』。例如 [0-9] 代表 0 刡 9 乊间癿所有数字,因为数字癿诧系编码是连续癿!
[^]|若中括号内癿第一个字符为挃数符号 (^) ,那表示『反向选择』,例如 [^abc] 代表 一定有一个字符,叧要是非 a, b, c 癿其他字符就接叐癿意思。

`bash` 中的特殊符号

符号|内容
---|---
#|批注符号:这个最常被使用在 script 当中,规为说明!在后癿数据均丌执行
\ |跳脱符号:将『特殊字符戒通配符』还原成一般字符
\| |管线 (pipe):分隑两个管线命令癿界定(后两节介绍);
;|连续挃令下达分隑符:连续性命令癿界定 (注意!不管线命令幵丌相同)
~|用户癿家目录
$|叏用发数前导符:亦即是发量乊前需要加癿发量叏代值
&|工作控刢 (job control):将挃令发成背景下工作
!|逡辑运算意义上癿『非』 not 癿意思!
/|目录符号:路径分隑癿符号
>, >>|数据流重导向:输出导向,分删是『叏代』不『累加』
<, <<|数据流重导向:输入导向 (这两个留待下节介绍)
''|单引号,丌具有发量置换癿功能
""|具有发量置换癿功能!
``|两个『 ` 』中间为可以先执行癿挃令,亦可使用 $( )
()|在中间为子 shell 癿起始不结束
{}|中间为命令区块的组合!

# 数据流导向

数据流重导向可以将 `standard output` 与 `standard error output` 分别传送到其他的档案或装置去。

```
标准输入： 代码为 0 ，使用 < or <<
标准输出： 代码为1， 使用 > or >>
标准错误输出： 代码为 2 ，使用 2> 2>>
```

eg:

> ll /
> ll / > ~/rootfile
> ll ~/rootfile

数据流| 结    果
---|:---:
1> :|以覆盖癿方法将『正确癿数据』输出刡挃定癿档案戒装置上;
1>>:|以累加癿方法将『正确癿数据』输出刡挃定癿档案戒装置上;
2> :|以覆盖癿方法将『错诨癿数据』输出刡挃定癿档案戒装置上;
2>>:|以累加癿方法将『错诨癿数据』输出刡挃定癿档案戒装置上;

eg:

> find /home -name .bashrc > list_right 2> list_error

- `dev/null` 的用法

 > find /home -name .bashrc > list 2>&1

- `standard inout` ,作用就是输入文件中的内容

```
cat > catfile
testing
cat file test
ctrl + d
```

> cat >catfile < ~/.bashrc

> cat > catfile << "eof"

利用 `<<` 右侧的控制字符，可以终止一次输入，而不必用 `[ctrl + d]` 来结束。

## 什么时候用数据流重定向呢？

- 需要将屏幕信息保存
- 背景执行中的程序
- 系统例行执行的结果
- 一些命令可能已知有错误
- 错误信息和正确信息要分别输出

# 命令执行的判断依据 `；，&&，||`
 
指令之间用 `；` 分开。

- `$? && ||`

```
ls /tmp/abc && touch /tmp/abd/hehe
ls /tmp/abc || mkdir /tmp/abc
ls /tmp/abc || mkdir /tmp/abc && touch /tmp/abc/hehe
```

# 管道命令

管道命令只会处理 `standard output`， 对于 `stardand error output` 会予以忽略；管道命令必须要能够接受来自前一个指令的数据成为 `stardand input` 继续处理才行。

## `cut` 和 `grep`

eg：

> echo $PATH | cut -d ':' -f 5

- `grep`

> last | grep 'root' | cut -d'' -f1

## `sort,wc,uniq`
