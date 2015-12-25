---
layout: post
title: Mac Keyboard
---

Macを私用と業務等で、複数台使うようになったのでキーボード設定とツールをメモ！

■ツール

- <a href="#karabiner">Karabiner</a>
- <a href="#google_IME">Google 日本語入力</a>
- <a href="#formatmatch">FormatMatch</a>
- <a href="#bettertouchtool">BetterTouchTool</a>

■その他

- <a href="#caps_lock">USキーボードの caps lock を ctrl に変更</a>

<hr />

<h2 id="karabiner">【Karabiner】</h2>
Karabinerの設定変更で、キーボード入力を高速に！

- まず、<a href="https://pqrs.org/osx/karabiner/index.html.ja" target="_blank">Karabiner</a>をダウンロード
- Key Repeat -&gt; Basic Configurations -&gt; Key Repeat 内の Delay Until Repeat と Key Repeat の秒数を変更

[![]({{ site.url }}/img/posts/keyboard/karabiner.png)]({{ site.url }}/img/posts/keyboard/karabiner.png)

おすすめはこれぐらい。

<code>
Delay Until Repeat =&gt; 250ms /
Key Repeat =&gt; 15ms
</code>

### ※For USキーボードの人
スペースキー の両隣の commandキー にそれぞれ【英数/かな】変換キーを割り振ります。

[![]({{ site.url }}/img/posts/keyboard/us_keyboard.png)]({{ site.url }}/img/posts/keyboard/us_keyboard.png)

これで commandキー1発で、英数/かな変換が出来て高速！

<hr />

<h2 id="google_IME">【Google 日本語入力】</h2>
Macではデフォルトで「ことえり」というIMEが使われていますが、日本語変換予測は安心のGoogleクオリティーに変える。(完全に趣向)

- まず、<a href="http://www.google.co.jp/ime/index-mac.html" target="_blank">Google 日本語入力</a>をダウンロード
- 使わない入力ソースをOffにする

Macのシステム環境設定 -&gt; キーボード -&gt; 入力ソース

[![]({{ site.url }}/img/posts/keyboard/google_IME.png)]({{ site.url }}/img/posts/keyboard/google_IME.png)

<hr />

<h2 id="formatmatch">【FormatMatch】</h2>
ブラウザからコピーしたテキストをgmailなどにペーストした時に、テキストスタイルが残っている。。

いちいちテキストスタイルのリセットを毎回するのも面倒なので、ツールで解決！

<a href="https://itunes.apple.com/jp/app/formatmatch/id445211988?mt=12" target="_blank">FormatMatch</a>をダウンロード

これでコピペの際、元のテキストのスタイルを気にしなくて済みます。

※テキストのスタイルをそのまま使いたい場合に、

Preferences -&gt; shortcuts から、起動/終了のショートカットを設定できます。

<hr />

<h2 id="bettertouchtool">【BetterTouchTool】</h2>
<a href="http://blog.boastr.net/" target="_blank">BetterTouchTool</a>でトラックパッドでの操作をストレスフリーに！

- window をらくらく動かしたり、サイズ変更をスムーズにやりたい場合

Adbanced -> ActionSettings -> Window Moving &Resizing

[![]({{ site.url }}/img/posts/keyboard/bettertouchtool.png)]({{ site.url }}/img/posts/keyboard/bettertouchtool.png)

- トラックパッドのカーソルキーの動きを速くする

Simple -&gt; Basic Settings -&gt; Set trackpad -&gt; speed から、カーソルキーの動く速さをレンジバーで設定できます。
一度Maxの速さに慣れてしまうと、もう戻れません。笑

<hr />

<h2 id="caps_lock">【USキーボードの caps lock を ctrl に変更】</h2>
Macのシステム環境設定 -&gt; 修飾キー から、caps lock キーを ctrl キー にリマップ

[![]({{ site.url }}/img/posts/keyboard/caps_lock.png)]({{ site.url }}/img/posts/keyboard/caps_lock.png)

※caps lockキーは、shiftを押しながらアルファベットキーを押すことが出来ない人の為だそうな。
なるほど、クレカのフォームで名前入れる時にも便利ですが、必要なキーですね。
