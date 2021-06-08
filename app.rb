require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'

#JSON形式でtitleとarticleをmemos.jsonに書き出す
def write_to_json_file(hash)
  File.open("./json/#{hash['id']}.json", 'w') do |file| 
    JSON.dump(hash, file)
  end
end

def fetch_memos_from_json_file
  json_files = Dir.glob('json/*').sort_by { |file| File.birthtime(file) }
  json_files.map { |file| JSON.parse(File.read(file)) }
end

get '/' do
  redirect("/memos")
end

get '/memos' do
  @all_memos = fetch_memos_from_json_file
  erb :top
end

post '/memos' do
  new_memo = {
    'id' => SecureRandom.uuid, 
    "title" => params[:title],
    "article"=> params[:article]
  }
  write_to_json_file(new_memo)
  redirect('/memos')
end

get '/memos/new' do
  erb :new
end

get '/memos/edit' do
  erb :edit
end

get '/memos/show' do
  erb :show
end
