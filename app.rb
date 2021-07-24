require 'sinatra'
require 'sinatra/reloader'
require 'json'

# get '/memo/*' do |name|
#   "hello #{name}. how are you?"
# end

class Memo
  attr_accessor :id, :text, :title

end

get '/memo' do
  memos = JSON::Parser.new(File.open('./data/sample.json').read, object_class: Memo)
  @memos = memos.parse

  erb :index
end

get '/memo/new' do
  erb :new
end

get '/memo/*/edit' do
  erb :edit
end

# patch '/memo/*/edit' do
#   erb :index
# end

post '/memo' do
  # 投稿の処理
  erb :index
end

# get '/memo/*/edit' do |name|
#     "hello #{name}. how are you?"
# end