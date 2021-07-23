require 'sinatra'
require 'sinatra/reloader'

get '/' do
  'fine!'
end

get '/path/to' do
  "this is [/path/to]"
end

# get '/memo/*' do |name|
#   "hello #{name}. how are you?"
# end

get '/memo' do
  erb :index
end

get '/memo/new' do
  erb :new
end

get '/memo/*/edit' do
  erb :edit
end

# get '/memo/*/edit' do |name|
#     "hello #{name}. how are you?"
# end