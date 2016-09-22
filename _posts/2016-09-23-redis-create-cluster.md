---
layout: post
title: Redis create-cluster scripts
---

Redis cluster を簡単に立ち上げるスクリプトとして、[create-cluster](https://github.com/antirez/redis/tree/3.2/utils/create-cluster) が用意されている。
ローカル開発やテスト環境に便利。

中身をみると、bashスクリプト内で、`redis-trib.rb` を呼んで実行しています。
`redis-trib.rb`は、redisのgem が必要なので、

```
$ gem install redis
```

しておく必要がある。

もっとも簡単にclusterを立ち上げるには、以下2つのコマンドでいけます。

```
$ ./create-cluster start
$ ./create-cluster create
```

途中で`yes`とタイプを求められるのが、CIでのテスト時等には面倒。。

```
$ ./create-cluster create
>>> Creating cluster
>>> Performing hash slots allocation on 6 nodes...
Using 3 masters:
127.0.0.1:30001
127.0.0.1:30002
127.0.0.1:30003
Adding replica 127.0.0.1:30004 to 127.0.0.1:30001
Adding replica 127.0.0.1:30005 to 127.0.0.1:30002
Adding replica 127.0.0.1:30006 to 127.0.0.1:30003
Can I set the above configuration? (type 'yes' to accept):

>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join..
>>> Performing Cluster Check (using node 127.0.0.1:30001)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

以下のように、パイプを使って繋ぐといけます。

```
$ yes "yes" | ./create-cluster create
```

※ `-y`のような自動入力出来るオプションあるか確認してみたのですが、関数 `yes_or_die`で常に標準入力を求めてるので、ここを改変してもいける。

[https://github.com/antirez/redis/blob/3.2/src/redis-trib.rb#L815-L822](https://github.com/antirez/redis/blob/3.2/src/redis-trib.rb#L815-L822)
