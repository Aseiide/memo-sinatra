# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'haml'

# JSON形式でtitleとarticleをmemos.jsonに書き出す
def write_to_json_file(hash)
  File.open("json/#{hash['id']}.json", 'w') do |file|
    JSON.dump(hash, file)
  end
end

def pull_memos_from_json_file
  json_files = Dir.glob('json/*').sort_by { |file| File.birthtime(file) }
  json_files.map { |file| JSON.parse(File.read(file)) }
end

get '/' do
  redirect('/memos')
end

get '/memos' do
  @all_memos = pull_memos_from_json_file
  haml :top
end

post '/memos' do
  new_memo = {
    'id' => SecureRandom.uuid,
    'title' => params[:title],
    'article' => params[:article]
  }
  write_to_json_file(new_memo)
  redirect('/memos')
end

get '/memos/new' do
  haml :new
end

get '/memos/:id/edit' do
  id = params[:id]
  @result = pull_memos_from_json_file.find { |x| x['id'].include?(id) }
  haml :edit
end

patch '/memos/:id' do
  edited_memo = {
    'id' => params[:id],
    'title' => params[:title],
    'article' => params[:article]
  }
  # json以下のファイルが存在する時にpatchの処理を行う
  if File.exist?("./json/#{params[:id]}.json") == true
    write_to_json_file(edited_memo)
    redirect('/memos')
  else
    raise 'このメモは存在しません'
  end
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
  '404エラー'
end
