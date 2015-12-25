---
layout: post
title: vim clipboard
---

macのvimでは、クリップボードがデフォルトでは使えない。。

<strong><span style="color: #339966;">vimでも自由にコピペ出来るようにする！</span></strong>

## 1, vimの諸々の設定を確認
{% highlight bash linenos %}
$ vim --version
{% endhighlight %}

すると、下のような設定が諸々見れる。

<pre>
VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Nov 16 2014 00:24:20)
MacOS X (unix) version
Included patches: 1-488
Compiled by Homebrew
Huge version without GUI.  Features included (+) or not (-):
+acl             +farsi           +mouse_netterm   +syntax
+arabic          +file_in_path    +mouse_sgr       +tag_binary
+autocmd         +find_in_path    -mouse_sysmouse  +tag_old_static
-balloon_eval    +float           +mouse_urxvt     -tag_any_white
-browse          +folding         +mouse_xterm     -tcl
++builtin_terms  -footer          +multi_byte      +terminfo
+byte_offset     +fork()          +multi_lang      +termresponse
+cindent         -gettext         -mzscheme        +textobjects
....
</pre>

下のコマンドで、<strong>clipboard</strong>の設定を確認。
{% highlight bash linenos %}
$ vim --version | grep clipboard 
{% endhighlight %}

<pre>
-clientserver -clipboard +cmdline_compl +cmdline_hist +cmdline_info +comments 
 -xterm_clipboard -xterm_save
</pre>
標準インストールされているvimでは、<strong>-clipboard</strong>でクリップボードと連携していない。。


## 2, Homebrewでvimをインストール
{% highlight bash linenos %}
$ brew update
$ install vim
{% endhighlight %}

インストールしたvimのclipboardの設定を確認。
{% highlight bash linenos %}
$ /usr/local/Cellar/vim/インストールされたバージョン/bin/vim --version | grep clipboard
+clipboard       +iconv           +path_extra      -toolbar
+eval            +mouse_dec       +startuptime     -xterm_clipboard
{% endhighlight %}

## 3, 既存のvimとインストールしたvimを入れ替える
{% highlight bash linenos %}
$ sudo mv /usr/bin/vim /usr/bin/vim_7_3
// バージョンの古い方のvimをmv
$ sudo ln /usr/local/Cellar/vim/インストールされたバージョン/bin/vim /usr/bin/
// シンボリックリンクをはる
{% endhighlight %}

## 4, vimrcに設定
最後は、vimrcに下記1行を設定して完了。
{% highlight bash linenos %}
set clipboard=unnamed
{% endhighlight %}

### おまけ
{% highlight bash linenos %}
set clipboard=unnamed,autoselect
{% endhighlight %}
上記も可能。

※個人的には、autoselectは、vimのvisual modeで選択したものがそのままヤンクされるので、厄介だったりする時がある。。

#### .vimrc でのclipboardの意味

<pre>
unnamed		ヤンクしたテキストをOSのクリップボードにコピー
autoselect	vimで選択したテキストがクリップボードにコピー
</pre>
