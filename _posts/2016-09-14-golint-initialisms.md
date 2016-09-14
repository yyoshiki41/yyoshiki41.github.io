---
layout: post
title: golint Initialisms
---

golint でしかられるInitialismsの定義場所を忘れるので、メモ。

Initialisms の導入については、[ここ](https://github.com/golang/go/wiki/CodeReviewComments#initialisms)。

例えば、`Url` という変数を定義してしまった場合、下記のようにコーディングスタイルにそぐわないことを教えてくれる。

```
var Url should be URL
```

定義場所は下記で、

[golang/lint](https://github.com/golang/lint) の `lint.go` に

```
var commonInitialisms = map[string]bool{
	"API":   true,
	...
}
```

として、定義されている。
