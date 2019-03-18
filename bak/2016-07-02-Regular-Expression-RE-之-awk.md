---
title: Regular Expression(RE) 之 awk
date: 2016-07-02 10:39:21
tags:
  - awk
---
## `awk`

也是一个数据处理工具，与 `sed` 的主要区别是 `awk` 倾向于将一行分成数个 『字段』 来处理。

> awk '条件类型1{动作1}条件类型2{动作2}...' filename

`awk` 默认的字段分割符是 『空格键』和 『tab』键。

> last -n 5 | awk '{print $1 "\t" $3}'

<!-- more -->
1. 读入第一行，并将第一行的资料填入 `$0,$1,$2...`
2. 依据『条件类型』的限制，判断是否需要进行后面的『动作』
3. 做完所有的动作与条件类型
4. 处理后续内容

### `awk` 内建变量

变量名称 | 代表意义
---|---
NF | 每一行拥有的字段总数
NR | 目前 `awk` 所处理的是『第几行』数据
FS | 目前的分割字符，默认是空格键

- 列出每一行的帐号
- 目前处理的行数
- 该行的字段数

> last -n 5 | awk '{print $1 "\t lines:" NR "\t columes:" NF}'

### `awk` 的逻辑运算字符

```
cat /etc/passwd | awk '{FS=":"} $3 < 10{print $1 "\t" $3}'
cat pay.txt | \

awk 'NR==1{printf"%10s %10s %10s %10s%10s\n",$1,$2,$3,$4,"Total" }NR>=2{total = $2 + $3 + $4 printf "%10s %10d %10d %10d %10.2f\n", $1, $2, $3, $4, total}'
```
make
1. 'awk' 动作需要多个指令辅助时，可利用分号 `；`间隔，或者直接以『enter』来隔开
2. 注意 `==`
3. `printf` 中的分行
4. `awk` 的变量可以直接使用

`awk` 的输出格式当中，常常会用 `printf` 进行辅助，且 `awk` 的动作内 `{}` 也支持 `if` 条件。

> cat pay.txt |  awk '{if(NR==1) printf"%10s...}'

## diff



## cmp
## patch


# pr
