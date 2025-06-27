# frozen_string_literal: true

require 'pg'

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
