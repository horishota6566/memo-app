# frozen_string_literal: true

require 'pg'
require 'connection_pool'

DB_POOL = ConnectionPool.new(size: 5, timeout: 5) do
  PG.connect(dbname: 'memo-app')
end

def with_connection
  DB_POOL.with do |connection|
    yield connection
  end
end

def read_all
  with_connection do |connection|
    result = connection.exec('SELECT * FROM memos;')
    result.map { it.transform_keys(&:to_sym) }
  end
end

def read(id)
  with_connection do |connection|
    result = connection.exec_params(
      'SELECT * FROM memos WHERE id = $1;',
      [id]
    )
    result.first.transform_keys(&:to_sym)
  end
end

def create(params)
  with_connection do |connection|
    result = connection.exec_params(
      'INSERT INTO memos (title, content) VALUES ($1, $2) RETURNING *',
      [params[:title], params[:content]]
    )
    result.first.transform_keys(&:to_sym)
  end
end

def update(params)
  with_connection do |connection|
    result = connection.exec_params(
      'UPDATE memos SET title = $1, content = $2 WHERE id = $3 RETURNING *;',
      [params[:title], params[:content], params[:id]]
    )
    result.first.transform_keys(&:to_sym)
  end
end

def delete(id)
  with_connection do |connection|
    result = connection.exec_params(
      'DELETE FROM memos WHERE id = $1;',
      [id]
    )
  end
end
