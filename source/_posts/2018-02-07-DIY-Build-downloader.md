---
title: 家用工具 DIY 一 下载机
date: 2018-02-07 11:30:08
updated:
tags:
---

手头有有一个 ci20，感兴趣的可参考 [MIPS开发板的“不二”选择——Creator Ci20单板计算机评测](http://imgtec.eetrend.com/news/9084) , [MIPS开发板的“不二”选择——Creator Ci20单板计算机评测](http://www.cnblogs.com/findumars/p/6794403.html)这个东西类似于树莓派，其流行度和社区支持远没有树莓派好, 其母公司已经被中国厂商收购了。但是这东西的可玩性还是很不错的，先配置一个下载机玩吧，主要是用来下载 youtube 上的视频的。

<!-- more -->
# Showsocks on server 及 BBR 加速

我参考的文章如下：

- [各平台vps快速搭建shadowsocks及优化总结](https://quericy.me/blog/495/)
- [搬瓦工OpenVZ 平台 Google BBR 一键安装脚本](http://www.bawagon.com/openvz-google-bbr/), 如果你也用 bwh， 请注意的对应的平台。
- [在Ubuntu OS的VPS上架设Shadowsock服务器端](http://blog.csdn.net/lcg0412/article/details/45009113)

- [从零开始：史上最详尽Shadowsocks搭建教程](https://www.iwwenbo.com/0-1-shadowsocks-start/)

参考已上内容，应该可以配置成功的。


# Install shadowsocks

Shadowsocks 有好几种安装方式：

- 使用 pip 安装
- 带 GUI 的shadowsocks-qt5
- showsocks-libenv

>如果你用系统是 Debain， 请先更换国内的源，可参考 [告别缓慢为 Debian 8 Jessie 更换国内的源](https://yorkchou.com/debian-8-mirror.html) 或者 [使用国内的 Debian 源和镜像](https://www.zzxworld.com/blogs/use-cn-mirror-for-debian.html)

下载机需要在**终端使用代理**，而且平时都是通过 ssh 远程登陆使用的。安装过程可参考: [Ubuntu下ss的安装与使用](https://www.cnblogs.com/Dumblidor/p/5450248.html), 配置代理模式之后的内容无需参考。

> sslocal 启动如果报 undefined symbol: EVP_CIPHER_CTX_cleanup 错误，参阅  [Kali2.0 update到最新版本后安装shadowsocks服务报错问题](http://blog.csdn.net/blackfrog_unique/article/details/60320737)

参考 [如何在mac上使用polipo将socks5转换成http](https://www.zybuluo.com/aliasliyu4/note/561047) 将 socks5 转成 http。

# Install youtube-dl

详见 [https://github.com/rg3/youtube-dl/blob/master/README.md#readme](https://github.com/rg3/youtube-dl/blob/master/README.md#readme)

- youtube-dl --download-archive archive.txt "URL"  下载当前页面下的所有视频
- youtube-dl --yes-playlist -f bestvideo+bestaudio -playlist-start NUMBER "URL"  下载列表下的视频


有一个问题是直接用上述命令下载时速度较慢，可以使用 aria2c 实现并行。

# Install aria2c

<!-- aria2c 还可以加速 pan.baidu.com 上的资源，感兴趣的可以 google 一下。 -->

安装参考： [https://github.com/aria2/aria2](https://github.com/aria2/aria2)

并行加速参考 [https://github.com/rg3/youtube-dl/issues/350#issuecomment-256621096](https://github.com/rg3/youtube-dl/issues/350#issuecomment-256621096)
