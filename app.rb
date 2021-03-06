# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'haml'
require 'pg'

# データベースとの接続
before do
  @connection = PG.connect(dbname: 'memo_sinatra')
  
# JSON形式でtitleとarticleをmemos.jsonに書き出す
def write_to_json_file(hash)
  basename = File.expand_path('/json', __dir__)
  filename = File.expand_path(File.join(basename, hash['id']))
  memo_id = File.basename(filename)
  raise if basename !=
           File.expand_path(File.join(File.dirname(filename), './'))

  File.open("json/#{memo_id}.json", 'w') do |file|
    JSON.dump(hash, file)
  end
end

# データを追加
def create_memo(hash)
  query = 'INSERT INTO memos (id, title, article) VALUES ($1, $2, $3)'
  @connection.exec(query, [hash['id'], hash['title'], hash['article']])
end

# idを取得してデータを編集
def update_memo(hash)
  query = 'UPDATE memos SET title = $1, article = $2 WHERE id = $3'
  @connection.exec(query, [hash['title'], hash['article'], hash['id']])
end

# idを取得してデータを削除
def delete_memo(id)
  query = 'DELETE FROM memos WHERE id = $1'
  @connection.exec(query, [id])
end

# idを取得してtitleとarticleをselectする
def bring_from_memo(id)
  query = 'SELECT title, article FROM memos where id = $1'
  @connection.exec(query, [id])
end

# DBから全idのタイトルを取得
def select_from_memos
  memos_data = 'SELECT * FROM memos'
  @connection.exec(memos_data)
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

  write_to_json_file(edited_memo)
  redirect('/memos')
end

get '/memos/:id' do
  # idのメモのtitleとarticleを表示する
  id = params[:id]
  @result = pull_memos_from_json_file.find { |x| x['id'].include?(id) }
  haml :show
end

delete '/memos/:id' do
  # 削除するファイルがjson以下のファイルと一致するのかチェックが必要
  id = params[:id]
  # メモのファイルが格納されているpathを取得
  basename = File.expand_path('./json', __dir__)

  # idで渡ってきたjson内のファイル名を取得
  filename = File.expand_path(File.join(basename, id))

  # リクエストで飛んでくるファイル名とbasenameが一致しなかったらraise
  raise if basename !=
           File.expand_path(File.join(File.dirname(filename), './'))

  # filenameと一致するものがあったら削除
  File.delete("#{filename}.json")
  redirect('/memos')
end

not_found do
  'このページは見つかりませんでした。違うURLを入力してください。'
end
