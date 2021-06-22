# memo sinatra

「Sinatra でシンプルな Web アプリを作ろう」という課題で作成したメモアプリです。

## Installation

1. `git clone https://github.com/Aseiide/memo-sinatra.git` を実行して任意のディレクトリにクローンしてください
2. `cd memo-sinatra` で`memo-sinatra`ディレクトリに移動してください
3. `bundle install`を実行してください。
4. `bundle exec ruby app.rb`とするとローカルでアプリが立ち上がります
5. メモの新規作成、編集、削除を行うことができます

## DataBase(PostgreSQL)

ローカル環境で PostgreSQL のインストールが完了した後、以下の手順に沿ってデータベースを作成してください。
PostgreSQL がまだインストールできていない方は[こちらの記事](https://qiita.com/ksh-fthr/items/b86ba53f8f0bccfd7753)を参考にインストールしてください。

以下ではデータベース名:`memo_sinatra`, テーブル名:`memos`を想定しています。

1. コマンドラインから`createdb memo_sinatra -O owner_name;`を入力しデータベースを作成
2. `psql -l`で 1 で作成したデータベースを確認
3. `psql -U user_name -d hogehoge`で DB に接続
4. | Column  | Type                  |
   | ------- | --------------------- |
   | id      | character varying(40) |
   | title   | text                  |
   | article | text                  |

   以上のようなデータ型を持った`memosテーブル`を作成してください

以上でデータベースの準備は完了です。
