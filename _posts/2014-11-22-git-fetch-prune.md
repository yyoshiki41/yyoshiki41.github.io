---
layout: post
title: git fetch --prune
---

削除されたremote branchが、CUIでは表示される...

GUIツールでは、消えてるのになぜ...? と気になったので、
リモートブランチの操作方法をまとめます！

■基本

- <a href="#show">リモートブランチの表示</a>
- <a href="#delete">リモートブランチの削除</a>
- <a href="#fetch">リモートブランチを取り込む</a>

■ちょい発展

- <a href="#prune">`git fetch --prune`</a>

<h2 id="show">1. リモートブランチの表示</h2>

{% highlight bash linenos %}
$ git branch -a
* master
  temp
  remotes/origin/master
  remotes/origin/temp
{% endhighlight %}

&nbsp;

<h2 id="delete">2. リモートブランチの削除</h2>

{% highlight bash linenos %}
$ git push origin :temp
{% endhighlight %}

すると、リモートブランチの `temp` が削除されます。

{% highlight bash linenos %}
$ git branch -a
* master
  temp
  remotes/origin/master
{% endhighlight %}

&nbsp;

<h2 id="fetch">3. リモートブランチを取り込む</h2>
複数人で開発している場合、
他の人がリモートにpushしたブランチを取り込みたい時に、以下のコマンドを実行します。

{% highlight bash linenos %}
$ git fetch
{% endhighlight %}

#### <span style="color: #333399;">ここで、`git fetch` は<strong>リモートブランチを取ってくるだけ</strong>です。</span>

&nbsp;

<h2 id="prune">4. リモートに存在していないブランチを、自分のローカルからも削除したい</h2>
他の人が削除したはずのリモートブランチが、ローカルレポジトリでは表示される場合

{% highlight bash linenos %}
$ git branch -a
* master
  temp
  remotes/origin/master
  remotes/origin/other  <= 実際のリモートブランチでは削除されてるのに、表示される！！
{% endhighlight %}

以下のコマンドを実行します。

{% highlight bash linenos %}
$ git fetch --prune
x [deleted]         (none)     -> origin/other
{% endhighlight %}

`remotes/origin/other` が無事削除されました！！

<strong>git fetch</strong> がリモートのものを取り込むだけ(削除されたブランチもローカルではそのまま)、
<strong>prune</strong> をオプションとして付けると、リモートで削除されたブランチも更新してくれます！

ちなみに、prune をデフォルト設定にもできるみたいです。

参考：<a href="http://hail2u.net/blog/software/git-config-fetch-prune.html" target="_blank">http://hail2u.net/blog/software/git-config-fetch-prune.html</a>
