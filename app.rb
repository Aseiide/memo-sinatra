require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'haml'

#JSON形式でtitleとarticleをmemos.jsonに書き出す
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
  redirect("/memos")
end

get '/memos' do
  @all_memos = pull_memos_from_json_file
  haml :top
end

post '/memos' do
  new_memo = {
    'id' => SecureRandom.uuid, 
    'title' => params[:title],
    'article'=> params[:article]
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
  write_to_json_file(edited_memo)
  redirect('/memos')
end

get '/memos/show' do
  haml :show
end

get '/memos/:id' do
  #idのメモのtitleとarticleを表示する
  id = params[:id]
  @result = pull_memos_from_json_file.find { |x| x['id'].include?(id) }
  haml :show
end

delete '/memos/:id' do
  File.delete("json/#{params['id']}.json")
  redirect('/memos')
end
