---
title: libgtk-3-bin or libgtk-3-common error connot install any packages
date: 2018-01-28 00:01:52
updated:
tags:
---


Ubuntu 安装软件时报错：

> ibgtk-3-0: Depends: libgtk-3-common (>=3.14.5-1…) but it is not going to be installed


解决方案：

```
dpkg --remove libgtk-3-bin
edited /var/lib/dpkg/status and remove the lines for adwaita-icon-theme
```

删除 adwaita-icon-theme 时有一个包名即为 adwaita-icon-theme， 需将整个包相关的段落删除。
