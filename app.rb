require 'sinatra'
require_relative 'marvel.rb'

get '/' do
  @total = Marvel.new.get_the_characters('1')['total']
  @img = Marvel.new.get_the_characters('1')['results'][0]['thumbnail'].values.join(".")
  @character_names = Marvel.new.people_in_comics([162,30090]).collect{|r| r['name'] }.join(", ")
  erb :home
end

get '/table' do
  @characters = Marvel.new.get_the_characters('50')['results']
  erb :table
end