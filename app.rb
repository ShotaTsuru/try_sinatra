# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/escape'

helpers do
  def escape(text)
    CGI.escape_html(text)
  end
end

error 404 do
  status 404
end

class Memo
  require 'pg'
  attr_accessor :id, :title,  :text
  def initialize(memo_contents)
    @id = memo_contents['memo_id']
    @title = memo_contents['title']
    @text = memo_contents['text']
  end

  def self.escape(text)
    CGI.escape_html(text)
  end

  def self.unescape(text)
    CGI.unescape_html(text)
  end

  def self.all
    conn = PG.connect(dbname: 'try_sinatra_db')
    conn.exec('SELECT * FROM memos') do |r|
      memos = r.map do |row|
        memo = Memo.new(row)
        memo
      end
      memos
    end
  end

  def self.create(params)
    conn = PG.connect(dbname: 'try_sinatra_db')
    title = params['title']
    text = params['text']
    conn.exec(
      "INSERT INTO memos (title, text) VALUES ('#{title}', '#{text}')"
    )
  end

  def self.find(id)
    conn = PG.connect(dbname: 'try_sinatra_db')
    conn.exec("SELECT * FROM memos WHERE memo_id = '#{id}'") do |r|
      memo = Memo.new(r[0])
      memo
    end
  end

  def self.update(params)
    conn = PG.connect(dbname: 'try_sinatra_db')
    conn.exec("
      UPDATE memos
      SET title = '#{params['title'])}', text = '#{params['text']}'
      WHERE memo_id = '#{params['id']}'
      ")
  end

  def self.destroy(id)
    conn = PG.connect(dbname: 'try_sinatra_db')
    conn.exec("
      DELETE FROM memos
      WHERE memo_id = '#{id}'
      ")
  end
end

# topページへ
get '/memo' do
  @memos = Memo.all
  erb :index
end

# 新規投稿ページへ
get '/memo/new' do
  erb :new
end

# 投稿の保存処理
post '/memo' do
  Memo.create(params)
  redirect to('/memo')
end

# 詳細ページへ
get '/memo/:id' do
  @memo = Memo.find(params[:id])
  erb :show
end

# 削除処理
delete '/memo/:id' do
  Memo.destroy(params[:id])
  redirect to('/memo')
end

# 編集ページへ
get '/memo/:id/edit' do
  @memo = Memo.find(params[:id])
  erb :edit
end

# 編集処理
patch '/memo/:id' do
  Memo.update(params)
  redirect to('/memo')
end
