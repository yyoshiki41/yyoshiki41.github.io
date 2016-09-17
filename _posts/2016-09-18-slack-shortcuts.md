---
layout: post
title: Slack shortcuts using karabiner
---

slack用のキーボードショートカットをkarabinerを使って、設定したメモ。

`private.xml` の設定方法は、[公式](https://pqrs.org/osx/karabiner/document.html.en#privatexml)にあるので、割愛。

設定のxmlファイルは、Github で管理してます。

[https://github.com/yyoshiki41/dotfiles/tree/master/misc/karabiner](https://github.com/yyoshiki41/dotfiles/tree/master/misc/karabiner)

### 1. Ctrl+Tab(+Shift) で、未読Ch/DMに移動

ブラウザとかで、タブ間を移動するときに使うのと同じキーバインド。

```
<!-- Ctrl+Tab で、未読チャネルを下に移動 -->
<autogen>__KeyToKey__ KeyCode::TAB, ModifierFlag::CONTROL_L, ModifierFlag::NONE, KeyCode::CURSOR_DOWN, ModifierFlag::OPTION_L, ModifierFlag::SHIFT_L</autogen>
<!-- Ctrl+Tab+Shift で、未読チャネルを上に移動 -->
<autogen>__KeyToKey__ KeyCode::TAB, ModifierFlag::CONTROL_L, ModifierFlag::SHIFT_R, KeyCode::CURSOR_UP, ModifierFlag::OPTION_L, ModifierFlag::SHIFT_L</autogen>
```

※ `<autogen>` だけのせてます。

`Ctrl+Tab`で未読チャネルを下に移動する設定に、`ModifierFlag::NONE`を付けておかないと、
次の`Ctrl+Tab+Shift`がマッピングできないのに若干ハマった。

`private.xml` の公式リファレンスは[こちら](https://pqrs.org/osx/karabiner/xml.html.en)。

### 2. Ctrl+n/p で、Ch/DMを上下に移動

```
<autogen>__KeyToKey__ KeyCode::N, ModifierFlag::CONTROL_L, KeyCode::CURSOR_DOWN, ModifierFlag::OPTION_L</autogen>
<autogen>__KeyToKey__ KeyCode::P, ModifierFlag::CONTROL_L, KeyCode::CURSOR_UP, ModifierFlag::OPTION_L</autogen>
```

これは未読既読に関係なく、移動するショートカット。

※ 独自で`private.xml`を書かなくても、オプション機能として[Emacs風キーバインドを反映させる設定](https://pqrs.org/osx/karabiner/gallery.html.ja#use-emacs-key-bindings-everywhere)が提供されてます。

### Tips

`private.xml` は、以下のように`<include />`を使うようにしてます。

`dotfiles` と相性良いのと、見やすくなるので。

```
<?xml version="1.0"?>
<root>
  <include path="{{ ENV_HOME }}/dotfiles/misc/karabiner/slack.xml" />
  <include path="{{ ENV_HOME }}/dotfiles/misc/karabiner/iterm.xml" />
</root>
```
