require 'rubygems'
require 'sinatra'
require 'coffee-script'

get '/' do
  erb :main
end