---
layout: post
title: horenso introduction
---

[horenso](https://github.com/Songmu/horenso) を導入したので、そのメモ。

> ["horensoというcronやコマンドラッパー用のツールを書いた"](http://www.songmu.jp/riji/entry/2016-01-05-horenso.html)

使い方は、上のブログや README を読んでもらえれば、問題ないかと思います。

下記のようなslack通知させる簡単な`reporter`をRubyでかきました。

<script src="https://gist.github.com/yyoshiki41/b342c8b62e659536fa910322900c380a.js"></script>

horensoから受け取ったjsonの`exitCode`をみて、異常終了した時だけ通知させる。

[![]({{ site.url }}/img/posts/horenso/slack.png)]({{ site.url }}/img/posts/horenso/slack.png)

cron以外にも下のような手元で長時間のジョブ実行時に完了通知させるのにも便利。

```
$ horenso -r "ruby /path/to/reporter.rb" -- sleep 1h
```
