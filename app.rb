require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'

get '/' do
  redirect("/memos")
end

get '/memos' do
  erb :top
end

post '/memos' do
  @title = params[:title]
  @article = params[:article]
  memos = {
    'id' => SecureRandom.uuid, 
    "title" => @title,
    "article"=> @article
  }
  File.open("./json/memos.json", 'w') do |file| 
  JSON.dump(memos, file)
  end
  erb :top
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
