require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'pry-byebug'

def asset_stats
    url = URI("https://api.opensea.io/api/v1/collections?asset_owner=0x740025ab2bf4a38ca54cd8405f658403afd36260&offset=0&limit=300")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    user_serialized = response.read_body
    user = JSON.parse(user_serialized)

    user.each_with_index do |arr, index|
        if arr["primary_asset_contracts"].empty?
            puts "no name"
        else
            puts arr["primary_asset_contracts"][0]["name"]
        end
        puts floor(arr["slug"])
    end
end

def floor(slug)
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://api.opensea.io/api/v1/collection/#{slug}/stats")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Accept"] = 'application/json'

    response = http.request(request)
    user_serialized = response.read_body
    user = JSON.parse(user_serialized)

    user["stats"]["floor_price"]
end

asset_stats