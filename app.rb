# frozen_string_literal: true

# require 'sinatra'
# require 'sinatra/reloader'
# require 'securerandom'
# require 'haml'
require 'pg'

# データベースとの接続
def connect_to_db
  PG.connect( dbname: 'memo_sinatra' )
end

# データを追加
def create_memo(title, article)
  create_memo_query = "INSERT INTO memos (title, body) VALUES ('#{title}', '#{article}') RETURNING id"
  connect_to_db.exec(create_memo) {|result| result[0]['id']}
end

# idを取得してデータを編集
def update_memo(id, title, body)
  update_memo_query = "UPDATE memos SET (title, body) = ('#{title}', '#{body}') WHERE id = #{id}"
  connect_to_db.exec(update_memo_query)
end

# idを取得してデータを削除
def delete_note(id)
  delete_note_query = "DELETE FROM memos WHERE id = #{id}"
  connect_to_db.exec(delete_note_query)
end
