---
title: Regular Expression(RE) 之 grep
date: 2016-06-30T09:06:56.000Z
tags:
  - 写给自己看的教程
---

![logo](/images/bash.png)`grep` 是最常见的支持『正则表达式』的命令，最重要的功能就是进行字符串数据的比对，然后将符合用户需求的字符串打印出来。 `grep` 的查找是以『行』为单位，通过一些参数选项可以实现几乎任何需求，一句话就是『就怕你想不到』。`grep` 高级选项:
<!-- more -->
- `-A` ：--> `after`
- `-B` " --> `before`
- `--color=auto` : --> 高亮搜索结果
- `-n` ： 显示行号

练习可以在鸟哥的网站[下载](http://linux.vbird.org/linux_basic/0330regularex/regular_express.txt)， 或直接在命令行下载 `wget http://linux.vbird.org/linux_basic/0330regularex/regular_express.txt`。


# 1. 搜索特定字符串

> grep -n 'the' Regular-expression.txt


![grep1](/images/grep1.png)
其中参数 `-n` 为 `number`

> grep -vn 'the' regular_express.txt


![grep2](/images/grep2.png)
其中 `-v` 为 `reverse`

> grep -in 'the' regular_express.txt

![grep3](/images/grep3.png)

其中 `-i` 为 `ignore`

# 2. 利用 `[]` 搜索字符

> grep -n 't[ae]st' regular_express.txt

![grep4](/images/grep4.png)

`[]` 的作用是从 `[]` 中选且仅选『一个』字符，就是一个『组合问题』。

> grep -n 'oo' regular_express.txt

![grep5](/images/grep5.png)

> grep -n '[^g]oo' regular_express.txt

![grep6](/images/grep6.png)

以上的几个例子的结果都是显而易见的，但这个例子的结果有点意思。为什么会出现第 `18` 和 `19` 行呢？ **注意**： `grep` 以『整行』为单位，且行内的多个结果间是『与』的关系。

> grep -n '[^a-z]oo' regular_express.txt

![grep7](/images/grep7.png)

常见的『集合字符』有: `[a-z]` , `[A-Z]`, `[0-9]`。怎么解释 `[a-zA-Z0-9]`.

![grep8](/images/grep8.png)

> grep -n '[^[:lower:]]oo' regular_express

![grep9](/images/grep9.png)

`关键字` ： `[]`, `[^]`, `[-]`

# 3. 行首及行尾符号的用法

> grep -n '^the' regular_express.txt

![grep10](/images/grep10.png)

```
grep -n '^[a-z]' regular_express.txt
grep -n '^[[:lower:]]' regular_express.txt
grep -n '^[^a-zA-Z]' regular_express.txt
grep -n '\.$' regular_express.txt
```
![grep11](/images/grep11.png)

最后一个命令并没有显示出所有的『看似』符合的文本，为什么呢？ 使用 `cat -A` 查看一下就知道了。

```
grep -v '^$' regular_express.txt
grep -v '^$' /etc/syslog.conf | grep -v '^#'
```
# 4. 任意一个字符 `.` 和 重复字符 `*`

> grep  -n 'g..d' regular_express.txt

![grep12](/images/grep12.png)

至少有两个以上 `oo` 时怎么写呢？ `'ooo*'`.

```
grep -n 'ooo*' regular_express.txt
grep -n 'goo*g' regular_express.txt
grep -n 'g*g' regular_express.txt
```
![grep13](/images/grep13.png)

**注意**： `g*g` 的意思是『行』内『至少有一个』 字母 `g`.

![grep14](/images/grep14.png)

> grep -n 'g.*g' regular_express.txt

`*` 的意思是『0个或重复多个前面的字符』。

> grep -n '[0-9][0-9]*'

# 5. 限制连续 `RE` 字符范围 `{}`

> grep -n 'o\{2\}' regular_express.txt

用数学方法表示就是『大于等于』的关系

```
➜  regular-expression grep -n 'o\{2\}' regular_express.txt
1:"Open Source" is a good mechanism to develop programs.
2:apple is my favorite food.
3:Football game is not use feet only.
9:Oh! The soup taste good.
18:google is the best tools for search keyword.
19:goooooogle yes!
```

> grep -n 'go\{2,5\}g' regular_express.txt

```
➜  regular-expression grep -n 'go\{2,5\}g' regular_express.txt
18:google is the best tools for search keyword.
```

> grep -n 'go\{2,\}g' regular_express.txt


等价于

> grep -n 'gooo*g' regular_express.txt

# 6. 特殊字符汇总

`RE` 字符 | 意义及范例
:---|:----
^word | 意义:待搜寻的字符串(`word`)在行首!<br>范例:搜寻行首为 `#` 开始的那一行,并列出行号<br>`grep -n '^#' regular_express.txt`
word$|意义:待搜寻字符串(`word`)在行尾!<br>范例:将行尾为 `!` 那一行打印出来,并列出行号<br>`grep -n '!$' regular_express.txt`
.|意义:代表『一定有一个任意字符』的字符!<br>范例:搜寻的字符串可以是 `(eve) (eae) (eee) (e e)`, 但不能仅有 `(ee)` !亦即 `e` 与 `e` 中间『一定』仅有一个字符!<br>`grep -n 'e.e' regular_express.txt`
\\|意义:跳脱字符,将特殊符号的特殊意义去除!<br>范例:搜寻有单引号 `'` 的那一行!<br>`grep -n \' regular_express.txt`
*|意义:重复零个到无穷多个的前一个 `RE` 字符<br>范例:找出有 `(es) (ess) (esss)` 等等的字符串,注意,因为 `\*` 可以是 0 个,所以 `es` 也是符合带搜寻字符串。另外,因为 \* 为重复『前一个 `RE` 字符』的符号, 因此,在 \* 前必须要紧接着一个 `RE` 字符喔!例如任意字符则为 『\.\*』 !<br>`grep -n 'ess*' regular_express.txt`
[list]|意义:字符集合的 `RE` 字符,里面列出想要提取的字符!<br>范例:搜寻有 `(gl)` or `(gd)` 的那一行,需要特别留意的是在 `[]` 当中『谨代表一个待搜寻的字符』, 例如『 `a[afl]y` 』代表搜寻的字符串可以是 `aay, afy, aly` 即`[afl]` 代表 `a` or `f` or `l` 的意思!<br>`grep -n 'g[ld]' regular_express.txt`
[n1-n2]|意义:字符集合的 `RE` 字符,里面列出想要提取的字符范围!<br>范例:搜寻有任意数字的那一行!需特别留意,在字符集合 `[]` 中的减号 `-` 是有特殊意义的,他代表两个字符间的所有连续字符!但这个连续不否不 `ASCII` 编码有关, 例如所有大写字符则为 [A-Z]<br>`grep -n '[0-9]' regular_express.txt`
[^list]|意义:字符集合的 `RE` 字符,里面列出不要的字符串范围!<br>范例:搜寻的字符串可以是 `(oog) (ood)` 但不能是 `(oot)` ,那个 `^` 在 `[]` 内时,代表的意义是『反向选择』的意思。 例如,我不要大写字符,则为 `[^A-Z]`。但是,需要特别注意的是,如果以 `grep -n [^A-Z] regular_express.txt` 搜寻,即该档案内的所有行都被列出,为什么?因为这个 `[^A-Z]` 是『非大写字符』的意思, 因为每一行均有非大写字符,例如第一行的 `"Open Source"` 就有 `p,e,n,o....`等等的小写字<br>`grep -n 'oo[^t]' regular_express.txt`
\{n,m\}|意义:连续 `n` 到 `m` 个的『前一个 `RE` 字符』<br>意义:若为 \{n\} 则是连续 `n` 个的前一个 `RE` 字符, 意义:若是 `\{n,\}` 则是连续 `n` 个以上的前一个 `RE` 字符! <br>范例:在 `g` 与 `g` 间有`2` 个到 `3` 个的 `o` 存在的字符串,亦即 `(goog)(gooog)`<br>`grep -n 'go\{2,3\}g' regular_express.txt`


# 练习

```
grep ‘^Mr’ filename
grep ‘sh$’ filename
grep –v ‘^$’ filename
grep ‘ba*s’ filename
grep ‘b.*h’ filename
grep ‘x[a-z]m’ filename
grep ‘[^ac]’ filename
grep ‘[’ filename
grep 'le\>' testfile
grep '\<fe' testfile
grep `whoami` /etc/passwd
grep smug files	{search files for lines with 'smug'}
grep '^smug' files	{'smug' at the start of a line}
grep 'smug$' files	{'smug' at the end of a line}
grep '^smug$' files	{lines containing only 'smug'}
grep '\^s' files	{lines starting with '^s', "\" escapes the ^}
grep '[Ss]mug' files	{search for 'Smug' or 'smug'}
grep 'B[oO][bB]' files	{search for BOB, Bob, BOb or BoB }
grep '^$' files	{search for blank lines}
grep '[0-9][0-9]' file	{search for pairs of numeric digits}
grep '^From: ' /usr/mail/$USER	{list your mail}
grep '[a-zA-Z]'	{any line with at least one letter}
grep '[^a-zA-Z0-9]	{anything not a letter or number}
grep '[0-9]\{3\}-[0-9]\{4\}'	{999-9999, like phone numbers}
grep '^.$'	{lines with exactly one character}
grep '"smug"'	{'smug' within double quotes}
grep '"*smug"*'	{'smug', with or without quotes}
grep '^\.'	{any line that starts with a Period "."}
grep '^\.[a-z][a-z]'	{line start with "." and 2 lc letters}
```
