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
  create_memo_query = "INSERT INTO memos (id, title, article) VALUES ($1, $2, $3), '#{hash['id']}', '#{hash['title']}', '#{hash['article']}'";
  connect_to_db.exec(create_memo_query)
end

# idを取得してデータを編集
def update_memo(hash)
  update_memo_query = "UPDATE memos SET title = '#{hash["title"]}', article = '#{hash["article"]}' WHERE id = '#{hash["id"]}'";
  connect_to_db.exec(update_memo_query)
end

# idを取得してデータを削除
def delete_memo(id)
  delete_memo_query = "DELETE FROM memos WHERE id = '#{id}'";
  connect_to_db.exec(delete_memo_query)
end

# idを取得してtitleとarticleをselectする
def bring_from_memo(id)
  bring_memo_query = "SELECT title, article FROM memos where id = '#{id}'";
  connect_to_db.exec(bring_memo_query)
end

# DBから全idのタイトルを取得
def select_from_memos
  memos_data = "SELECT * FROM memos";
  connect_to_db.exec(memos_data)
end

get '/' do
  redirect('memos')
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
  redirect('memos')
end

get '/memos/:id' do
  id = params[:id]
  @result = bring_from_memo(id)[0]
  haml :show
  # binding.irb
end

get '/memos/:id/edit' do
  id = params[:id]
  @result = bring_from_memo(id)[0]
  haml :edit
end

patch '/memos/:id' do
  edited_memo = {
    'id' => params[:id],
    'title' => params[:title],
    'article' => params[:article]
  }
  update_memo(edited_memo)
  redirect('memos')
end

delete '/memos/:id' do
  id = params[:id]
  delete_memo(id)
  redirect('memos')
end
