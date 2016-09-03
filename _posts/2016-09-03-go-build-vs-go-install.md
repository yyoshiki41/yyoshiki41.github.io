---
layout: post
title: go build vs go install
---

[Cross compilation with Go 1.5](http://dave.cheney.net/2015/08/22/cross-compilation-with-go-1-5)

上のblogを読んでいて、_Using go build vs go install_ の部分が気になったので、その検証。

blog自体のテーマはGoのクロスコンパイルの話で、雑に言うと

「クロスコンパイルする必要があるプロジェクト = `go build` を使え。」

という内容。気になったのは、

> because go build builds, [then throws away most of the result](http://dave.cheney.net/2014/06/04/what-does-go-build-build) (rather than caching it for later), leaving you with the final binary in the current directory, which is most likely writeable by you.

という箇所。`go build` はビルドの過程で生成されたオブジェクトファイルなどを捨てているという点。

クロスコンパイルの際に、違うプラットフォームのキャッシュを使いたくない。だから、`go build` でやるべきというロジック。

(もし、ビルド時間が長いことが大きな問題なら、各プラットフォームのgoバイナリを自分でビルドすることを対処として紹介している。)

## 検証

適当なレポジトリで検証してみる。

### go build

```
$ time go build
go build  1.85s user 0.25s system 109% cpu 1.921 total

# go build 後のpkg以下をみる
# 何も残っていない
$ ls $GOPATH/pkg/darwin_amd64/github.com/yyoshiki41/go-gmail-drafts/ | wc -l
       0
```

### go install

```
$ time go install
go install  1.87s user 0.25s system 111% cpu 1.908 total

# go build 後のpkg以下をみる
# libというパッケージのキャッシュが残っている
$ ls $GOPATH/pkg/darwin_amd64/github.com/yyoshiki41/go-gmail-drafts/ | wc -l
       1
$ ls $GOPATH/pkg/darwin_amd64/github.com/yyoshiki41/go-gmail-drafts/
lib.a
```

[nm](https://golang.org/cmd/nm/) でオブジェクトファイルの中身を見てみる。

```
$ go tool nm $GOPATH/pkg/darwin_amd64/github.com/yyoshiki41/go-gmail-drafts/lib.a
         U
    5f66 T %22%22.CreateGmailConfig
    6367 R %22%22.CreateGmailConfig·f
    60b6 T %22%22.init
    635f B %22%22.initdone·
    636f R %22%22.init·f
    5ed6 T %22%22.readClient
    635f R %22%22.readClient·f
```

lib.a があると当然だけど、ビルド時間が短くなる。
(リンク処理するオブジェクトファイル`lib.a`を生成する必要がないので)

```
# lib.a なし
$ time go install
go install  1.86s user 0.25s system 110% cpu 1.924 total

# lib.a あり
$ time go install
go install  0.11s user 0.06s system 46% cpu 0.367 total
```

### `$GOPATH/pkg/`が残った状態での build vs install

`-x` オプションで実行結果を表示できるので、そのログを比較してみる。

[![]({{ site.url }}/img/posts/gobuild/diff.png)]({{ site.url }}/img/posts/gobuild/diff.png)

ワーキングディレクトリ名と最終的なバイナリのアウトプット先以外にはdiffがない。

つまり、`$GOPATH/pkg` 以下にファイルがあれば、`go build` 時でもそれが使われる。
