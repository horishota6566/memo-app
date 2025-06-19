# memo-app

## 概要

このアプリは、Sinatra と JSON ファイルを用いて作成したシンプルなメモアプリです。
ブラウザ上でメモの作成・編集・削除ができ、データはローカルの JSON ファイルに保存されます。
学習目的での軽量な CRUD アプリケーションです。

## 前提条件

- **Ruby** と **Bundler** がインストールされていること

  バージョン確認コマンド：

  ```sh
  ruby -v
  bundler -v
  ```

  ※ インストール手順は 公式サイト を参照してください。

## セットアップ手順

1. リポジトリを複製する

   好みの方法でクローンしてください：

   | 種類  | URL                                             |
   | ----- | ----------------------------------------------- |
   | HTTPS | `https://github.com/horishota6566/memo-app.git` |
   | SSH   | `git@github.com:horishota6566/memo-app.git`     |

   ```
   git clone <URL>
   cd memo-app
   ```

2. develop ブランチに切り替える

   `git switch develop`

3. 依存ライブラリをインストール

   `bundle install`

4. アプリケーションを起動

   `ruby app.rb`

5. ブラウザでアクセス

   `http://localhost:4567`
