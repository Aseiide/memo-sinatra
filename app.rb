# frozen_string_literal: true

# require 'sinatra'
# require 'sinatra/reloader'
# require 'securerandom'
# require 'haml'
require 'pg'

# データベースとの接続
def connect_to_db
  PG.connect( dbname: 'memo_sinatra' )
end

# def write_to_db(hash)
#   connect_to_db
#   conn.exec("INSERT INTO memos(id, title, article) VALUES ('#{hash['id']}', '#{hash['title']}', '#{hash['article']}')")
# end

def fetch_memos_from_db
  connect_to_db.exec("SELECT * FROM memos ORDER BY id") do |result|
    result.each do |row|
      puts "id: #{row["id"]}"
      puts "タイトル: #{row["title"]}"
      puts "メモ: #{row["article"]}"
    end
  end
end
fetch_memos_from_db

# def update_memo
#   conn = PG.connect( dbname: 'memo_sinatra' )
#   conn.exec("UPDATE memos SET title= 'さらに更新しました', article = 'さらに更新しました' WHERE id = '1234567'")
# end
# update_memo
