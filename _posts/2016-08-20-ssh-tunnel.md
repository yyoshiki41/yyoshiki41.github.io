---
layout: post
title: SSH Tunnel
---

[Sequel Pro](http://www.sequelpro.com/) で、SSH Port Forwarding を利用してのDBサーバーへの接続をよく行う。

構成としては、下記みたいなオーソドックスな構成。
(Bastionの`port: 43306`を、DBサーバーの`port: 3306`にバインド。)

[![]({{ site.url }}/img/posts/ssh-tunnel/client-bastion-db.png)]({{ site.url }}/img/posts/ssh-tunnel/client-bastion-db.png)

ふと、Sequel の接続方法が気になったので見てみた。

[![]({{ site.url }}/img/posts/ssh-tunnel/sequel.png)]({{ site.url }}/img/posts/ssh-tunnel/sequel.png)

上記のような設定に対して、

ssh-agentを起動して、クライアントマシンの`port: 56430`をBastionの`43306`にバインドしている。

```
$ ps aux | grep [s]sh
yyoshiki41        31480   0.0  0.1  2473624   5248   ??  U    10:41PM   0:00.04 /usr/bin/ssh-agent -l
yyoshiki41        31479   0.0  0.1  2464476   4204   ??  S    10:41PM   0:00.04 /usr/bin/ssh -v -N -S none -o ControlMaster=no -o ExitOnForwardFailure=yes -o ConnectTimeout=10 -o NumberOfPasswordPrompts=3 -o TCPKeepAlive=no -o ServerAliveInterval=60 -o ServerAliveCountMax=1 -p 22 yyoshiki41@bastion -L 56430:127.0.0.1:43306
```

もちろん、Sequelで接続した状態で、下記のようにMySQLクライアントで接続も可能。

```
$ mysql -uadmin -p -h127.0.0.1 --port=56430
Enter password:

mysql>
```

cf.

[Set up an SSH Tunnel](http://www.sequelpro.com/docs/Set_up_an_SSH_Tunnel)
