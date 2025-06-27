# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_all
  @title = 'All Memos'
  erb :index
end

get %r{/memos/(\d+)} do |id|
  @memo = read(id)
  @title = "Memo: #{@memo[:title]}"
  erb :show
end

get '/memos/new' do
  @title = 'Add Memo'
  erb :new
end

get '/memos/:id/edit' do |id|
  @memo = read(id)
  @title = 'Edit Memo'
  erb :edit
end

post '/memos' do
  halt 400, 'タイトルが必要です' if params[:title].strip.empty?
  memo = create(params)
  redirect "/memos/#{memo[:id]}"
end

patch '/memos/:id' do
  memo = update(params)
  redirect "/memos/#{memo[:id]}"
end

delete '/memos/:id' do |id|
  delete(id)
  redirect '/memos'
end

not_found do
  status 404
  '404 Not Found'
end

helpers do
  include ERB::Util

  def read_all
    connection = PG.connect(dbname: 'memo-app')
    result = connection.exec('SELECT * FROM memos;')
    result.map { |row| row.transform_keys(&:to_sym) }
    ensure connection.close
  end

  def read(id)
    connection = PG.connect(dbname: 'memo-app')
    result = connection.exec_params('SELECT * FROM memos WHERE id = $1;', [id])
    result.first.transform_keys(&:to_sym)
    ensure connection.close
  end

  def create(params)
    connection = PG.connect(dbname: 'memo-app')
    result = connection.exec_params(
      'INSERT INTO memos (title, content) VALUES ($1, $2) RETURNING *',
      [params[:title], params[:content]]
    )
    result.first.transform_keys(&:to_sym)
    ensure connection.close
  end

  def update(params)
    connection = PG.connect(dbname: 'memo-app')
    result = connection.exec_params(
      'UPDATE memos
      SET title = $1, content = $2
      WHERE id = $3
      RETURNING *;',
      [params[:title], params[:content], params[:id]]
    )
    result.first.transform_keys(&:to_sym)
    ensure connection.close
  end

  def delete(id)
    connection = PG.connect(dbname: 'memo-app')
    connection.exec_params('DELETE FROM memos WHERE id = $1;', [id])
    ensure connection.close
  end
end
