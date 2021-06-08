require 'sinatra'
require 'sinatra/reloader'

get '/memos' do
  erb :top
end

post '/memos' do
  @title = params[:title]
  @article = params[:article]
  memos = { "memo1" => { "title" => @title,"article"=> @article }}
  File.open("./json/memo.json", 'w') do |file| 
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
