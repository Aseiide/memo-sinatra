require 'sinatra'
require 'sinatra/reloader'

get '/memos' do
  erb :top
end

post '/memos' do
  @title = params[:title]
  @article = params[:article]
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
