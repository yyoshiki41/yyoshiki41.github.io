---
layout: post
title: Highlight go extra vars
---

["err"という文字列をHighlightしておくとGolangのコードリーディングが捗る](http://yuroyoro.hatenablog.com/entry/2014/08/12/144157)

上のブログを読んで、良いな！と思ったので、[vim-go](https://github.com/fatih/vim-go) にPRを送ってみました。

`err` だけでなく、_comma ok_というイディオムがあるくらいなので、`ok`もハイライト対象にしてみました。

[#1024 Add go_highlight_extra_vars option](https://github.com/fatih/vim-go/pull/1024)

結果的には、

> these are just ordinary variables.

ということで、クローズされました。(泣

まぁ仕方ないということで、 `.vimrc` に以下を追加しておきました。

```
autocmd FileType go :highlight goExtraVars cterm=bold ctermfg=136
autocmd FileType go :match goExtraVars /\<ok\>\|\<err\>/
```

見やすいので、オススメです！

[![](https://cloud.githubusercontent.com/assets/4014912/17977944/a4c34788-6b2e-11e6-954e-1a45e7231043.png)](https://cloud.githubusercontent.com/assets/4014912/17977944/a4c34788-6b2e-11e6-954e-1a45e7231043.png)
