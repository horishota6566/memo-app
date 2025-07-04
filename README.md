# memo-app

## 概要

このアプリは、Sinatra と PostgreSQL を使用して作成したシンプルなメモアプリです。
ブラウザ上でメモの作成・編集・削除ができ、データはローカルの PostgreSQL に保存されます。
学習目的での軽量な CRUD アプリケーションです。

## 前提条件

- **Ruby** と **Bundler** と**PostgreSQL**がインストールされていること

  バージョン確認コマンド：

  ```sh
  ruby -v
  bundler -v
  psql -V
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

4. データベースを作成し接続

   ```
   createdb memo-app
   psql memo-app
   ```

5. テーブルを作成

   ```
   CREATE TABLE memos (
   id SERIAL PRIMARY KEY,
   title TEXT NOT NULL,
   content TEXT
   );
   ```

6. アプリケーションを起動

   `bundle exec ruby app.rb`

7. ブラウザでアクセス

   `http://localhost:4567`
