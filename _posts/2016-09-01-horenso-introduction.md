---
layout: post
title: horenso introduction
---

[horenso](https://github.com/Songmu/horenso) を導入したので、そのメモ。

> ["horensoというcronやコマンドラッパー用のツールを書いた"](http://www.songmu.jp/riji/entry/2016-01-05-horenso.html)

使い方は、上のブログや README を読んでもらえれば、問題ないかと思います。

下記のようなslack通知させる簡単な`reporter`をRubyでかきました。

```
require 'net/http'
require 'uri'
require 'json'

resp = JSON.parse($stdin.gets)

if resp["exitCode"] != 0 then
  uri = URI.parse("https://hooks.slack.com/services/***")
  payload = {
    text: "```#{JSON.pretty_generate(resp)}```",
    channel: "@yyoshiki41",
    username: "Cron job fails",
    icon_emoji: ":scream_cat:"
  }
  Net::HTTP.post_form(uri, { payload: payload.to_json })
end
```

horensoから受け取ったjsonの`exitCode`をみて、異常終了した時だけ通知させる。

[![]({{ site.url }}/img/posts/horenso/slack.png)]({{ site.url }}/img/posts/horenso/slack.png)

cron以外にも下のような手元で長時間のジョブ実行時に完了通知させるのにも便利。

```
$ horenso -r "ruby /path/to/reprter.rb" -- sleep 1h
```
