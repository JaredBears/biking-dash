# Same here
# https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial

class GeoencoderController < ApplicationController

  #This controller is to interact with the geocoder api.  It will take an
  #address and return the coordinates, or take coordinates and return the
  #address.  This is a free service so long as I only use it less than once
  #per second.

  def geo_encode(address)
    uri = URI("https://geocode.maps.co/search?q=#{address}")
    pp uri
    response = Net::HTTP.get(uri)
    pp response
    json = JSON.parse(response)
    pp json
    coord = {
      lat: json[0]["lat"].to_f,
      lon: json[0]["lon"].to_f,
    }
    return coord
  end

  def reverse_geo(lat, lon)
    uri = URI("https://geocode.maps.co/reverse?lat=#{lat}&lon=#{lon}")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    address = json["address"]
    return address
  end
end
