---
layout: post
title: nginx APIエンドポイント毎のアクセス制御
---

この記事は、nginx Advent Calendar 2015の21日目の記事です。

はじめに
この記事では、nginxでのAPIエンドポイント毎のアクセス制御を行う方法をご紹介します！

ドメインベースでのアクセス制御(e.g.サービスの管理画面)は、AWSのセキュリティグループ設定等のネットワークレイヤーで行えます。
しかし同一ドメイン上で、APIエンドポイント毎にアクセス制御を行うような設定をしたい場合、アプリケーションやミドルウェアでロジックを記述することになると思います。
アプリケーションコード側で制御することも可能ですが、より低レイヤーな部分で不正なリクエストを止めることが、安全かつマシンリソース的にも嬉しいはずです。

今回、nginxで許可IPだけがAPIエンドポイントにアクセス出来るようにします。
ELBのようなL7ロードバランサの後ろで、動いているAppサーバを想定しています。

## 一覧

下記の3種類をロジックの書きやすさで「★」をつけながら書いていきます。

- if文のみでの制御
- ngx_http_geo_module での制御
- ngx_lua

## ■if文のみでの制御 (★☆☆)

単純なロジックの場合、下記で事足ります。
LB経由でリクエストを受けているため、
クライアントIPはnginx変数の$http_x_forwarded_forを使っています。

```
server {
    set $flag false;
    # Allow specific IPs
    if ($http_x_forwarded_for ~ ^123.4.5.6$) {
        set $flag true;
    }
    location ~ /endpoint/ {
        if ($flag = false) {
        return 403;
        }
        proxy_pass http://backend;
    }
}
```

しかし、複数の許可IPを記述したり、if文で複合条件を書こうとすると、
非常に醜いコードになってしまいます。

## ■ngx_http_geo_module での制御 (★★☆)

nginxのhttpモジュールに、ngx_http_geo_moduleというデフォルトで使用可能なモジュールがあります。
このモジュールはbuild時に、–without-http_geo_moduleで指定して外さない限り有効です。

気になる場合、nginx -Vで確認可能です。
(–without-http_geo_module が表示されなければ、使用可能です！)

```
# nginx -V はそのままだと見づらいので、ワンライナーで整形してます。
$ nginx -V 2>&1 | sed 's/--/\n--/g'
nginx version: nginx/1.6.2
built by gcc 4.8.2 20140120 (Red Hat 4.8.2-16) (GCC)
TLS SNI support enabled
configure arguments:
--with-ipv6
--with-http_ssl_module
--with-http_spdy_module
--with-http_realip_module
--with-http_addition_module
--with-http_image_filter_module
--with-http_geoip_module
~~ 省略 ~~
```

ngx_http_geo_moduleの使い方は、至って簡単です。
geoの後ろに、使用したいnginx変数を指定、その後ろにconfigファイル内で用いるflagを記述しています。
下記の例では$http_x_forwarded_forが、123.4.5.6もしくは234.5.6.7であれば、
$flagには、1がセットされます。

```
geo $http_x_forwarded_for $flag {
    default      0;
    123.4.5.6    1;
    234.5.6.7    1;
}
server {
    location ~ /endpoint/ {
        if ($flag = 0) {
            return 403;
        }
        proxy_pass http://backend;
    }
}
```

これであれば、複数の許可IPを記述していくケースでも、非常に理解しやすいものになります。
しかし、IPアドレス以外を用いるような複合条件を書きたい場合、問題解決にはなっていません。

## ■ngx_lua での制御 (★★★)

最後に紹介するのが、ngx_luaです。
スクリプト言語のLuaを用いて、nginxを拡張できるモジュールです。
今回は入門編として、OpenRestyをbuildから行い、ngx_luaを動かしたいと思います。
buildには@cubicdaiyaさんが、開発しているnginx-buildを使います。
(Goで書かれたシンプルなツールで、こちらの資料が詳しいです。)
まず、configure.sh として下記のようなものを用意しました。

```
#!/bin/sh
./configure \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/subsys/nginx \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
--http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
--with-http_stub_status_module \
--with-debug \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_gunzip_module \
--with-http_spdy_module \
--with-pcre-jit \
```

以下が実行手順となります。

```
# goのbuild環境が整っている場合
# go get -u github.com/cubicdaiya/nginx-build
# build済みのバイナリのみを取得する場合
$ wget https://github.com/cubicdaiya/nginx-build/releases/download/v0.6.4/nginx-build-linux-amd64-0.6.4.tar.gz -P /tmp/
$ tar xvzf /tmp/nginx-build-linux-amd64-0.6.4.tar.gz -C /usr/local/bin/
# work ディレクトリの作成
$ mkdir work
# option指定 & configure.shファイルを用意
$ nginx-build -clear -d work -openresty -pcre -openssl -zlib -c configure.sh
nginx-build: 0.6.4
Compiler: gc go1.5.2
~~ 省略 ~~
2015/12/21 00:00:00 Enter the following command for install nginx.
$ cd work/openresty/1.9.3.2/ngx_openresty-1.9.3.2
$ sudo make install
# 出力されたコマンドを素直に打つ!
$ cd work/openresty/1.9.3.2/ngx_openresty-1.9.3.2
$ sudo make install
$ nginx -V 2>&1 | sed 's/--/\n--/g'
nginx version: openresty/1.9.3.2
built by gcc 4.8.3 20140911 (Red Hat 4.8.3-9) (GCC)
built with OpenSSL 1.0.2e 3 Dec 2015
TLS SNI support enabled
configure arguments: --prefix=/usr/local/openresty/nginx --with-debug
~~ 省略 ~~
```

これで、ngx_luaを動かす環境が整いました。
下記のようにnginx.confで、luaのスクリプトファイルを読み込ませ、
Luaでアクセス制御のスクリプトを書いていきます。

```
# initファイル
init_by_lua_file '/etc/nginx/scripts/init.lua';
server {
    location ~ /endpoint/ {
        # 読み込ませるluaファイルのパス
        access_by_lua_file '/etc/nginx/scripts/access_control.lua';
        proxy_pass http://backend;
    }
}
$ cat init.lua
require 'resty.core'
-- ホワイトリストを定義。
whitelist = {'123.4.5.6', '234.5.6.7'}
$ cat access_control.lua
function access_control()
  -- nginx変数へアクセス
  local client_ip = ngx.var.http_x_forwarded_for
  for _, ip in iPairs(whitelist) do
    if ip == client_ip then
      return true
    end
  end
  return false
end
if access_control() == false then
  ngx.exit(ngx.HTTP_FORBIDDEN)
end
```

## 終わりに

いかがだったでしょうか？
マイクロサービス化が進むと、多数サービスとのAPI連携が必要になってきて、
きちんとアクセス制御を行ってあげないと思わぬ事故を招く可能性もあります。
IPのみでの判定であれば、ngx_http_geo_moduleが十分に威力を発揮しますが、
更に複雑なロジックの場合、Luaで記述することで非常に幅が広がります。
アプリケーション側の責務とミドルウェアの責務を明確に意識しながら、使うことが必須ですが、
ぜひぜひ機会がありましたら、ngx_luaでnginxをさらに拡張させてみてください。
