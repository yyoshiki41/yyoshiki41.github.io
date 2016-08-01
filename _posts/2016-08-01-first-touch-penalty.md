---
layout: post
title: AWS First Touch Penalty
---

AWSの各サービスのアーキテクチャに触れれるような示唆が得られたのでメモ。

Snapshotsから復元したRDSやEBSに対してReadの操作を行った際、初回アクセス時のレイテンシの悪化が見られた。

これがファーストタッチペナルティと呼ばれるもので、[公式Doc](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html#USER_PIOPS) には以下の記述がある。

> The first time a DB instance is started and accesses an area of disk for the first time, the process can take longer than all subsequent accesses to the same disk area.
> This is known as the "first touch penalty."

つまり、復元後の最初のアクセスのみレイテンシが悪化し、以降同じディスク領域へのアクセスを行ってもこのようなレイテンシの悪化は見られない。

### RDS

この理由は、アーキテクチャを通して説明を貰って非常に理解がしやすくなった。

これは、RDSのSnapshotsのデータが内部的にはS3(一般ユーザーが使っているものとは別かもしれないが、内部的なデータ・ストレージ)に保存されており、初回起動時にはEBSにデータが存在していないため、一度S3にアクセスし、データを取得するオーバヘッドが発生する。

(ちなみに、RDSの[Snapshotsの料金](https://aws.amazon.com/rds/pricing/)は一定の閾値を超えると標準のS3の料金が請求される。)

これを防ぐには、サービスイン前に下記のようなSQLでウォームアップを行うことがあげられる。(MySQLのウォームアップを行っていれば、図らずもファーストタッチペナルティの対策にもなっている。)

```
mysql> SELECT COUNT(*) FROM table;
```

### EBS

[EBSの公式Doc](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-initialize.html) では、直接ファーストタッチペナルティという言葉は記述されていないが同様のことが説明されている。

> However, storage blocks on volumes that were restored from snapshots must be initialized (pulled down from Amazon S3 and written to the volume) before you can access the block.
> This preliminary action takes time and can cause a significant increase in the latency of an I/O operation the first time each block is accessed.

Snapshotsから復元したEBSは、初回アクセス時にI/O操作でのレイテンシが増加する。

S3からデータを取得してきて、Volumeへ書き込んでいるため。という理由も明確に記述されており、初期化(ウォームアップのようなもの)が必要であると記述されている。

ちなみに、下記のコマンドで初期化(ウォームアップ)を行う。

(volumeのデータを読み込んで、 `/dev/null`に捨てているだけ。)

```
$ sudo dd if=/dev/xvdf of=/dev/null bs=1M
```


このようなウォームアップを行わずに、サービスインすると思わぬパフォーマンスの悪化に見舞われるので要注意。
(しかも次回以降は再現しないので、シューティングも非常に厄介になる..)
