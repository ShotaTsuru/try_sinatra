# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/escape'


class Memo
  require 'pg'
  attr_accessor :id, :text, :title

  conn = PG.connect( dbname: 'try_sinatra_db' )
  conn.exec( "SELECT * FROM memos" ) do |result|
    puts "     memo_id | title             | text | created_at | updated_at"
    result.each do |row|
      puts " %7d | %-16s | %s " %
        row.values_at('memo_id', 'title', 'text', 'created_at', 'updated_at', 'query')
    end
  end

  # def []=(key, value)
  #   instance_variable_set("@#{key}", value)
  # end

  def self.all
    conn = PG.connect( dbname: 'try_sinatra_db' )
    conn.exec("SELECT * FROM memos") do |r|
      memos = r.map do |row|
        memo = Memo.new
        memo.id = row["memo_id"]
        memo.title = row["title"]
        memo.text = row["text"]
        memo
      end
      memos
    end
  end

  def create
    conn.exec(
      "INSERT INTO memos VALUES ('id', 'title', 'text', 'created_at', 'updated_at')"
    )
  end
end

helpers do
  def escape(text)
    CGI.escape_html(text)
  end
end

error 404 do
  status 404
end

# topページへ
get '/memo' do
  # memos = JSON::Parser.new(File.open('./data/sample.json').read, object_class: Memo)
  # @memos = memos.parse
  @memos = Memo.all
  erb :index
end
# 新規投稿ページへ
get '/memo/new' do
  erb :new
end
# 投稿の保存処理
post '/memo' do
  memos_a = JSON::Parser.new(File.open('./data/sample.json').read).parse
  params[:id] = (memos_a[-1]['id'].to_i + 1).to_s
  user_input_escape(params)
  memos_a << params
  File.open('./data/sample.json', 'w') do |f|
    JSON.dump(memos_a, f)
  end
  redirect to('/memo')
end
# 詳細ページへ
get '/memo/:id' do
  memos = JSON::Parser.new(File.open('./data/sample.json').read).parse
  memo = memos.select { |n| n['id'] == params[:id] }
  @memo = JSON.parse(memo.to_json, object_class: Memo)[0]
  erb :show
end
# 削除処理
delete '/memo/:id' do
  memos = JSON::Parser.new(File.open('./data/sample.json').read).parse
  memos_a = memos.delete_if { |n| n['id'] == params[:id] }
  File.open('./data/sample.json', 'w') do |f|
    JSON.dump(memos_a, f)
  end
  redirect to('/memo')
end
# 編集ページへ
get '/memo/:id/edit' do
  memos = JSON::Parser.new(File.open('./data/sample.json').read).parse
  memo = memos.select { |n| n['id'] == params[:id] }
  @memo = JSON.parse(memo.to_json, object_class: Memo)[0]
  erb :edit
end
# 編集処理
patch '/memo/:id' do
  memos_a = JSON::Parser.new(File.open('./data/sample.json').read).parse
  memos_a.map! { |a| a['id'] == params['id'] ? params : a }
  File.open('./data/sample.json', 'w') do |f|
    JSON.dump(memos_a, f)
  end
  redirect to('/memo')
end
