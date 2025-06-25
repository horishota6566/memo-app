# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

MEMO_FILE = 'memos.json'

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = load_memos
  @title = 'All Memos'
  erb :index
end

get '/memos/new' do
  @title = 'Add Memo'
  erb :new
end

get '/memos/:id' do
  memos = load_memos
  @memo = find_memo(memos)
  @title = "Memo: #{@memo[:title]}"
  erb :show
end

get '/memos/:id/edit' do
  memos = load_memos
  @memo = find_memo(memos)
  @title = 'Edit Memo'
  erb :edit
end

post '/memos' do
  halt 400, 'タイトルが必要です' if params[:title].strip.empty?
  memos = load_memos
  new_id = (memos.map { it[:id] }.max || 0) + 1
  new_memo = {
    id: new_id,
    title: params[:title],
    content: params[:content].gsub(/\r\n?/, "\n")
  }
  memos << new_memo
  save_memos(memos)
  redirect "/memos/#{new_id}"
end

patch '/memos/:id' do
  memos = load_memos
  memo = find_memo(memos)
  memo[:title] = params[:title]
  memo[:content] = params[:content].gsub(/\r\n?/, "\n")
  save_memos(memos)
  redirect "/memos/#{memo[:id]}"
end

delete '/memos/:id' do
  memos = load_memos
  id = params[:id].to_i
  memos.reject! { it[:id] == id }
  save_memos(memos)
  redirect '/memos'
end

not_found do
  status 404
  '404 Not Found'
end

helpers do
  include ERB::Util

  def find_memo(memos)
    id = params[:id].to_i
    memo = memos.find { it[:id] == id }
    halt 404, 'メモが見つかりません' unless memo
    memo
  end

  def load_memos
    return [] if !File.exist?(MEMO_FILE) || File.zero?(MEMO_FILE)

    JSON.parse(File.read(MEMO_FILE), symbolize_names: true)
  end

  def save_memos(memos)
    File.write(MEMO_FILE, JSON.generate(memos))
  end
end
