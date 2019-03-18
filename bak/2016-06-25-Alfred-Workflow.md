---
layout: post
title: Alfred 「Workflow」
date: 2016-06-25 21:28
tags:
  - 写给自己看的教程
---

很长时间以来，这个在 `Mac` 上长期占据 `Top 1` 的神器令我无比向往。 那个时候我不知道 `Mac` 上的收费软件有团购，有冰点...  看看价格就在想这么高级的东西估计我也用不着，看着『美』就行了。最近实在是忍不了了，果断购之、学之、用之...

<!-- more -->
![alfred-mac-log](/images/alfred-mac-logo.png)

# 基础入门

以下是来自 `wikipedia` 的介绍

> Alfred is an application launcher and productivity application for Mac OS X. Alfred is free, though an optional paid upgrade ('Powerpack') is available.

> Using a keyboard shortcut chosen by the user, Alfred provides a quick way to find and launch applications and files on the Mac or to search the web both with predefined keywords for often-used sites such as Amazon.com, IMDB, Wikipedia and many others, with the ability to add users' custom searches for the sites most applicable to them. In its free version it also serves as a calculator, spell-checker and a convenient interface for controlling the Mac with system commands.

> Alfred's capabilities can be extended with the Powerpack which provides additional features, including the ability to directly navigate your file system, perform actions on the files and applications you search for, control iTunes, open Address Book entries, save text clips, and more. Alfred also allows you to set global hotkeys or access your URL history. There are hundreds of user-created extensions. A large repository for user-created workflows and themes created for Alfred 2 can be found at Packal.org.

> Alfred can be used as an alternative to OS X launchers such as Quicksilver and was created primarily with ease of use in mind. Alfred has garnered praise including 2011 Macworld Editors' Choice Award for the best Mac hardware and software of the year, being named TUAW's Best of 2011 Mac utility app and one of The 10 Best Mac Apps of 2011 by Mashable. It has also been recognised as one of 10 Must-have Apps for Mac Newbies by Maclife.com and a runner-up in MacStories Mac App of 2011 reader's choice.


- 如果搜索的关键字没有正确匹配，则默认用搜索引擎搜索
- `Alfred` 可以搜索文件，支持三种命令 `find` 在本地搜索文件、 `open` 打开本地文件 、 `in` 搜索文件内的内容。 `Finder` 中按 `Cmd + Opt + \` 弹出 `Action`窗口。
- 可以直接运行控制台命令
- `email` 加邮箱地址
- 开机、关机、重启、打开垃圾桶......

# workflow

`workflow` 有四个基本对象： `trigger`、 `keyword`、 `action`、 `output`。其中 `trigger`、 `keyword` 会出发后续动作； `Action` 负责处理用户需求， `output` 输出结果。

1. 启动快速文件搜索，默认搜索内容只要留应用、偏好设置和联系人就可以了。
2. `⌥+⌘+\` 文件或文件夹操作
3. 按 `~` 或 `/` 激活文件浏览器， `⌘+上键/下键` 退出/进入目录
4. 浏览最新历史纪录 `previous` 或 `⌘+⌥+/ `
5. 快速浏览在 `Alfred` 中搜索到的文件--- `shift` 键
6.



































 
