---
layout: post
title: emacs key-bindings
---

vimrcに書いた、emacs風のkey bindings のメモ

実際のvimrcのコードは、<a href="#vimrc">こっち</a>

## 移動系
<table>
<tbody>
<tr>
<th>Keybord</th>
<th>Move</th>
</tr>
<tr>
<td>CTRL+a</td>
<td>行の先頭に移動</td>
</tr>
<tr>
<td>CTRL+e</td>
<td>行の末尾に移動</td>
</tr>
<tr>
<td>CTRL+b</td>
<td>1文字左に移動</td>
</tr>
<tr>
<td>CTRL+f</td>
<td>1文字右に移動</td>
</tr>
</tbody>
</table>

## 操作
<table>
<tbody>
<tr>
<th>Keybord</th>
<th>Action</th>
</tr>
<tr>
<td>CTRL+c</td>
<td>エスケープする</td>
</tr>
<tr>
<td>CTRL+h</td>
<td>cursor前の文字を削除(backspace)</td>
</tr>
<tr>
<td>CTRL+d</td>
<td>cursor下の文字を削除</td>
</tr>
<tr>
<td>CTRL+k</td>
<td>cursor下から行末までを削除</td>
</tr>
</tbody>
</table>

## ヒストリー
<table>
<tbody>
<tr>
<th>Keybord</th>
<th>History</th>
</tr>
<tr>
<td>CTRL+p</td>
<td>ヒストリーをさかのぼる</td>
</tr>
<tr>
<td>CTRL+n</td>
<td>ヒストリーを進める</td>
</tr>
</tbody>
</table>

## <strong id="vimrc">.vimrc</strong>
{% highlight bash linenos %}
" normal mode
" cursorから行末まで削除
nnoremap <silent> <C-k> d$
" insert mode
" emacs key bindings
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-d> <Del>
inoremap <C-k> <Esc>lc$

" command-line
" emacs key bindings
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
{% endhighlight %}
