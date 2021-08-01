# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi/escape'

class Memo
  attr_accessor :id, :text, :title

  def []=(key, value)
    instance_variable_set("@#{key}", value)
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
  parser = JSON::Parser.new(File.open('./data/database_file.json').read, object_class: Memo)
  @memos = parser.parse
  erb :index
end

# 新規投稿ページへ
get '/memo/new' do
  erb :new
end

# 投稿の保存処理
post '/memo' do
  memos = JSON::Parser.new(File.open('./data/database_file.json').read).parse
  params[:id] = if memos.empty?
                  '1'
                else
                  (memos[-1]['id'].to_i + 1).to_s
                end
  memos << params
  File.open('./data/database_file.json', 'w') do |f|
    JSON.dump(memos, f)
  end
  redirect to('/memo')
end

# 詳細ページへ
get '/memo/:id' do
  memos = JSON::Parser.new(File.open('./data/database_file.json').read).parse
  memo = memos.select { |n| n['id'] == params[:id] }
  @memo = JSON.parse(memo.to_json, object_class: Memo)[0]
  erb :show
end

# 削除処理
delete '/memo/:id' do
  memos = JSON::Parser.new(File.open('./data/database_file.json').read).parse
  memos.delete_if { |n| n['id'] == params[:id] }
  File.open('./data/database_file.json', 'w') do |f|
    JSON.dump(memos, f)
  end
  redirect to('/memo')
end

# 編集ページへ
get '/memo/:id/edit' do
  memos = JSON::Parser.new(File.open('./data/database_file.json').read).parse
  memo = memos.select { |n| n['id'] == params[:id] }
  @memo = JSON.parse(memo.to_json, object_class: Memo)[0]
  erb :edit
end

# 編集処理
patch '/memo/:id' do
  memos = JSON::Parser.new(File.open('./data/database_file.json').read).parse
  memos.map! { |a| a['id'] == params['id'] ? params : a }
  File.open('./data/database_file.json', 'w') do |f|
    JSON.dump(memos, f)
  end
  redirect to('/memo')
end
