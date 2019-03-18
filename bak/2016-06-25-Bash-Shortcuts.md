---
layout: post
title: Bash Shortcuts
date: '2016-06-25 16:00'
tags:
  - skills & tips
---

接触类 `Unix` 系统已经有好几年了，也在各种终端下敲过 `bash` [命令](http://ss64.com/osx/syntax-bashkeyboard.html)，但总数使用的不熟练，看到别人在 `bash` 下手指翻飞，如有神助，我也好好学习一下 `bash shortcut`。此就当是一个加深记忆的方式，边看，边练，边写.

<!-- more -->
# 光标的移动

- `CTRL + A`  和 `CRTL + E`

> 移动光标到命令行起始/结尾处

按住 `OPTION` 键，在当前命令行单击，可以跳到命令行任意位置。

- `CTRL + P` 和 `CTRL + N`

> 跳到上一下命令和下一个命令，和上下键的区别是：当前命令行有输入时，上下键不能跳转

按住 `OPTION` 点击上一行，跳到该处的命令。（试了一下，不怎么好使）

- `CTRL + U` 和 `CTRL + K`

> 从光标处向前删除到命令行开头/向后删除到命令行结尾

- `CTRL + W` 和 `ALT + D`

> 一整词为单位向前删除/向后删除命令行。如果你的 `iterm` 或 `Terminal` 没有进行过其他设置的话， `ALT + D` 只是输入一个 `∂` 字符。
>- `Terminal` 的设置： `preference` -> `Profiles` -> `Use Option as Meta key`

![terminal-option-key](/images/terminal-option-key-seting.png)

> - `iTerm` 的设置： `Preference` -> `Profiles` -> `Default` -> `keys` -> `+Esc`

![iterm-option-setting](/images/iterm-option-key-setting.png)
![iterm-option-setting2](/images/iterm-option-key-setting2.png)

- `CTRL + Y`

> 粘贴由上述由上述命令删除的内容

- `CTRL + XX`

> 光标在命令行起始处和光标处往返

- `ALT + B` 和 `ALT + F`

> 以单词为单位向前向后移动

- `ALT + C`

> 大写光标所在处字母并移动光标到单词末尾

- `ALT + U` 和 `ALT + L`

>  将光标所在处到单词末尾的所有字母变为大写/小写

- `ALT + T`

>  将光标所在出单词与之前的单词交换

- `CTRL + F` 和 `CTRL + B`

> 以字符为单位向前向后移动光标

- `CTRL + D` 和 `CTRL + H`

> 以字符为单位向前/后删除

- `CTRL + T`

> 交换当前字符与前一个字符

# Command Recall Shortcuts

- `CTRL + R`

> 搜索命令历史

- `CTRL + G`

> 退出命令搜索

- `CTRL + P` 和 `CTRL + N`

> 前一个/后一个历史命令

- `ALT + .`

> 提取前一条命令的最后一个单词

# Command Control Shortcuts

- `CTRL + L`
- `CTRL + S`
- `CTRL + Q`
- `CTRL + C`
- `CTRL + Z`

# Bash Bang Shortcuts

- `!!`

>  执行最后一条命令

- `!blah`
- `$!`
- `!$:p`
- `!*`
- `!*:p`
