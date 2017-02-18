---
layout: post
title: Show YouTube stats using gas
---

YouTube 動画の統計情報を、SpreadSheetsでレンダリングする時のスクリプト。

Google App Script で YouTube API を叩いて、SpreadSheets にレンダリングするだけのお手軽タスクです。

## 手順

### 1. API Key を作成

[GCPのコンソール画面](https://console.cloud.google.com/)でプロジェクトを作成して、YouTube Data API を有効にします。

YouTube Data API の詳しいレファレンスは、[こちら](https://developers.google.com/youtube/v3/getting-started)から。

このプロジェクト内で API Key を作成します。(API Key の制限をかけたいんですが、IPも変わるのでベストプラクティスは不明です。。)

### 2. SpreadSheets 作成

ツール > スクリプトエディタ から、以下のスクリプトをコピペ。

先ほどの`API_KEY`, `VIDEO_ID` (動画URL `https://youtube.com/watch?v=*******`の `v` パラメータの部分)を入れる。

<script src="https://gist.github.com/yyoshiki41/c7b5b839f1ab8872c52c1c7641b90910.js"></script>

### 3. 実行

初回は`trigger()`を実行して、認証画面にリダイレクトされるので承認する。

あとは、時間手動で実行されるように設定。

[![]({{ site.url }}/img/posts/gas/trigger.png)]({{ site.url }}/img/posts/gas/trigger.png)

### デモ

いい感じにグラフでみれます。

[![]({{ site.url }}/img/posts/gas/column.png)]({{ site.url }}/img/posts/gas/trigger.png)
[![]({{ site.url }}/img/posts/gas/graph.png)]({{ site.url }}/img/posts/gas/trigger.png)


### おまけ

[Analytics and Reporting APIs](https://developers.google.com/youtube/analytics/?hl=ja) というのもあるので、がっつりやりたい場合はこちらが良さそう。
