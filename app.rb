require 'sinatra'
require 'sinatra/reloader'
require 'json'

# get '/memo/*' do |name|
#   "hello #{name}. how are you?"
# end

class Memo
  attr_accessor :id, :text, :title
end

# topページへ
get '/memo' do
  memos = JSON::Parser.new(File.open('./data/sample.json').read, object_class: Memo)
  @memos = memos.parse

  erb :index
end
# 新規投稿ページへ
get '/memo/new' do
  erb :new
end

# 投稿の保存処理
post '/memo' do
  memos = JSON::Parser.new(File.open('./data/sample.json').read)
  memos_a = memos.parse
  params[:id] = memos_a[-1]["id"] + 1
  memos_a << params
  File.open('./data/sample.json', "w") do |f|
    JSON.dump(memos_a, f)
  end
  redirect to('/memo')
end

# 詳細ページへ
get '/memo/*' do
  erb :show
end

# 削除処理
delete '/memo/*/' do
  redirect to('/memo')
end

# 編集ページへ
get '/memo/*/edit' do
  erb :edit
end

# 編集処理
patch '/memo/*' do
  redirect to('/memo')
end

# get '/memo/*/edit' do |name|
#     "hello #{name}. how are you?"
# end