# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'haml'
require 'pg'

# データベースとの接続
def connect_to_db
  PG.connect( dbname: 'memo_sinatra' )
end

# データを追加
def create_memo(hash)
  create_memo_query = "INSERT INTO memos (id, title, article) VALUES ('#{hash["id"]}', '#{hash["title"]}', '#{hash["article"]}')"
  connect_to_db.exec(create_memo_query)
end

# idを取得してデータを編集
def update_memo(id, title, body)
  update_memo_query = "UPDATE memos SET (title, body) = ('#{title}', '#{body}') WHERE id = #{id}";
  connect_to_db.exec(update_memo_query)
end

# idを取得してデータを削除
def delete_note(id)
  delete_note_query = "DELETE FROM memos WHERE id = #{id}";
  connect_to_db.exec(delete_note_query)
end

# DBから全idのタイトルを取得
def select_from_memos
  memos_data = "SELECT title FROM memos";
  connect_to_db.exec(memos_data)
end

get '/' do
  redirect('/memos')
end

get '/memos' do
  # DBから全idのタイトルを取得して変数に格納
  @all_memos = select_from_memos
  haml :top
end

get '/memos/new' do
  haml :new
end

post '/memos' do
  new_memo = {
    'id' => SecureRandom.uuid,
    'title' => params[:title],
    'article' => params[:article]
  }
  create_memo(new_memo)
  redirect('/memos')
end
