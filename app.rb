require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :top
end

get '/new' do
  erb :new
end

get '/edit' do
  erb :edit
end

get '/show' do
  erb :show
end
