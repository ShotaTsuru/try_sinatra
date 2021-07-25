require 'sinatra'
require 'sinatra/reloader'
require 'json'

# get '/memo/*' do |name|
#   "hello #{name}. how are you?"
# end

class Memo
  attr_accessor :id, :text, :title
  def []=(key, value)
    instance_variable_set("@#{key}", value)
  end
end


def pick_up_file
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
  memos_a = JSON::Parser.new(File.open('./data/sample.json').read).parse
  params[:id] = (memos_a[-1]["id"].to_i + 1).to_s
  memos_a << params
  File.open('./data/sample.json', "w") do |f|
    JSON.dump(memos_a, f)
  end
  redirect to('/memo')
end

# 詳細ページへ
get '/memo/:id' do
  memos = JSON::Parser.new(File.open('./data/sample.json').read).parse
  memo = memos.select {|n| n["id"] == params[:id]}
  @memo = JSON.parse(memo.to_json, object_class: Memo)[0]
  erb :show
end

# 削除処理
delete '/memo/:id' do
  memos = JSON::Parser.new(File.open('./data/sample.json').read).parse
  memos_a = memos.delete_if {|n| n["id"] == params[:id]}
  File.open('./data/sample.json', "w") do |f|
    JSON.dump(memos_a, f)
  end
  redirect to('/memo')
end

# 編集ページへ
get '/memo/:id/edit' do
  memos = JSON::Parser.new(File.open('./data/sample.json').read).parse
  memo = memos.select {|n| n["id"] == params[:id]}
  @memo = JSON.parse(memo.to_json, object_class: Memo)[0]
  erb :edit
end

# 編集処理
patch '/memo/:id' do
  memos_a = JSON::Parser.new(File.open('./data/sample.json').read).parse
  memos_a.map!{|a| a["id"] == params["id"] ? params : a}
  File.open('./data/sample.json', "w") do |f|
    JSON.dump(memos_a, f)
  end
  redirect to('/memo')
end

# get '/memo/*/edit' do |name|
#     "hello #{name}. how are you?"
# end