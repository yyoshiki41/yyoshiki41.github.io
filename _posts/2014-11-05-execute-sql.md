---
layout: post
title: Execute sql file
---

コマンドラインから下記を実行する。

[実行したいファイル] に、
<pre>./create_table.sql</pre>
みたいなSQLファイルのパスを指定する。

{% highlight bash linenos %}
$ mysql -h [host名] [DB名] < [実行したいファイル] -u [ユーザー名] -p[パスワード]
{% endhighlight %}

ここで、2点注意が必要。

<strong>1. -p[パスワード] のみ、-pの後ろに空白があるとダメ。</strong>

(-h, -u 等は、空白があってもOK。)

<strong>2. -pの後ろに、直接パスワードを書くのはセキュリティ的に良くない。</strong>

理由：コマンドラインからの履歴でパスワードが丸見え。

対策：-p 以降の部分は入力せずしない。後で出てくる Enter password で入力。

{% highlight bash linenos %}
$ mysql -h [host名] [DB名] < [実行したいファイル] -u [ユーザー名] -p
Enter password:
{% endhighlight %}
