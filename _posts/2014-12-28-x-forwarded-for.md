---
layout: post
title: Get client IP from ELB
subtitle: X_FORWARDED_FOR
---

ELB経由でない場合に、現在ページをみているユーザーのIPを取得する場合
下記の定義済み変数で取得することができます。
{% highlight php linenos %}
$_SERVER['REMOTE_ADDR'];
{% endhighlight %}

<a href="http://php.net/manual/ja/reserved.variables.server.php">公式</a> 見ながら`var_dump($_SERVER);`すると、勉強になります。

### ■ELB経由の場合

ELBを設定している場合に、上記の方法で設定すると、
プロキシサーバのIPアドレス(ELBのIP)が格納されるため、
クライントのページを見ているユーザーのIPが取得出来ない。

その場合、以下でクライントのページを見ているユーザーのIPがセットされる。
{% highlight php linenos %}
$_SERVER['HTTP_X_FORWARDED_FOR'];
{% endhighlight %}

最後に、実装したサンプルをドン！
{% highlight php linenos %}
$value = $_SERVER['REMOTE_ADDR'];
// For ELB
if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
   $value = $_SERVER['HTTP_X_FORWARDED_FOR'];
}
{% endhighlight %}
