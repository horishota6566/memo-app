# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative 'model'

db = DBClient.instance

helpers do
  include ERB::Util
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = db.read_all
  @title = 'All Memos'
  erb :index
end

get %r{/memos/(\d+)} do |id|
  @memo = db.read(id)
  @title = "Memo: #{@memo[:title]}"
  erb :show
end

get '/memos/new' do
  @title = 'Add Memo'
  erb :new
end

get '/memos/:id/edit' do |id|
  @memo = db.read(id)
  @title = 'Edit Memo'
  erb :edit
end

post '/memos' do
  halt 400, 'タイトルが必要です' if params[:title].strip.empty?
  memo = db.create(params)
  redirect "/memos/#{memo[:id]}"
end

patch '/memos/:id' do
  memo = db.update(params)
  redirect "/memos/#{memo[:id]}"
end

delete '/memos/:id' do |id|
  db.delete(id)
  redirect '/memos'
end

not_found do
  status 404
  '404 Not Found'
end
