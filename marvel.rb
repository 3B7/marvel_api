require 'digest/md5'
require "net/http"
require "uri"
require 'json'
# require 'byebug'

class Marvel
  attr_reader :public_key, :private_key, :http

  def initialize(options={})
    @public_key= 'YOUR-PUBLIC-KEY'
    @private_key= 'YOUR-PRIVATE-KEY'
    uri= URI.parse("http://gateway.marvel.com")
    @http =  Net::HTTP.new(uri.host, uri.port)
  end

  def get_the_characters(limit_number)
    request=Net::HTTP::Get.new("/v1/public/characters#{auth_params(public_key,private_key)}&limit=#{limit_number}")
    @response = http.request(request)
    parsed_resp = JSON.parse(@response.body)
    parsed_resp['data']
  end

  def people_in_comics(comic_ids_array = [])
    request = Net::HTTP::Get.new("/v1/public/characters#{auth_params(public_key,private_key)}&comics=#{comic_ids_array.join(",")}")
    @response = http.request(request)
    parsed_resp = JSON.parse(@response.body)
    parsed_resp['data']['results']
  end

  def auth_params(publick,privatek)
    ts = Time.now.to_i
    hash = Digest::MD5.hexdigest("#{ts}#{privatek}#{publick}")
    "?ts=#{ts}&apikey=#{publick}&hash=#{hash}"
  end

end


## ANSWERS
# puts total = Marvel.new.get_the_characters('1')['total']
# puts thumbnail = Marvel.new.get_the_characters('1')['results'][0]['thumbnail'].values.join(".")
# character_names = Marvel.new.people_in_comics([162,30090]).collect{|r| r['name'] }.join(", ")
# puts "#{character_names}"
