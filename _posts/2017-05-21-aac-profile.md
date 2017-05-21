---
layout: post
title: AAC profile of radiko
---

[radigo](https://github.com/yyoshiki41/radigo) というradikoの録音ツールを書いていて、  
ダウンロードしたファイルの拡張子は`aac`だが、iTunes で開けなかったのでその対処法のメモ。

以下の記事が詳しい。

- [radikoのflvから取り出したAACはなぜiTunesで読めないのか？](http://d.hatena.ne.jp/zariganitosh/20100917/radiko_flv_he_aac_itunes)
- [AAC - Wikipedia](https://ja.wikipedia.org/wiki/AAC)

radiko のフォーマットである[HE-AAC の Wikipedia](https://ja.wikipedia.org/wiki/HE-AAC) にも記載があるが、再生できるようにiTunes 等でエンコードが可能である。

> iTunes 9以降、Winamp、SonicStage等で無料でエンコードが可能である。また『着うたフル』に使用されているコーデックとしても有名。オープンソースのライブラリとしては libaacplus[2] がある。


以下は、 QuickTime Player でエンコードした場合の手順。

## 手順

### 1. QuickTime Player で開く

[![]({{ site.url }}/img/posts/aac/step1.png)]({{ site.url }}/img/posts/aac/step1.png)

### 2. 「File」>「Export」>「iTunes」を選択

[![]({{ site.url }}/img/posts/aac/step2.png)]({{ site.url }}/img/posts/aac/step2.png)

### 3. Export が始まる

[![]({{ site.url }}/img/posts/aac/step3.png)]({{ site.url }}/img/posts/aac/step3.png)

### 4. iTunes で開けるようになる

iTunesがサポートしているプロファイル `AAC-LC (AAC Low Complexity)` になっていることが確認できる。

[![]({{ site.url }}/img/posts/aac/step4.png)]({{ site.url }}/img/posts/aac/step4.png)
