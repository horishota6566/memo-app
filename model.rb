# frozen_string_literal: true

require 'pg'

def with_connection
  connection = PG.connect(dbname: 'memo-app')
  yield(connection)
ensure
  connection.close
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
