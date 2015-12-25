---
layout: post
title: Homebrew commands
---

brew update　と　brew upgrade　は、なるほどッて感じ。

brew link　と　brew unlink　も知っとくと一時的なエラー対処にも便利。

| Commands | Description |
|:---------|:------------|
| brew -v | homebrewのversion確認 |
| brew list | インストールされてるものをリスト表示 |
| brew doctor | homebrewで問題がないか診断 |
| brew update | homebrew を最新にする(formulaも更新) |
| brew upgrade (***) | formula を更新(***だけを更新も可) |
| brew install *** | ***をインストール |
| brew remove *** | ***を削除 |
| brew prune | リンク切れのパッケージを削除 |
| brew search *** | ***がつくものを検索 |
| brew info *** | ***の情報を表示 |
| brew log | homebrew の git logをみれる |
| brew (un)link *** | 一時的に***を有効(無効)にする |
| brew tap user/repository | 公開されているリポジトリを指定して、公式以外のformulaを取り込む |
