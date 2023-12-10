class GeoencoderController < ApplicationController
  def geo_encode(address)
    uri = URI("https://geocode.maps.co/search?q=#{address}}")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    coord = {
      lat: json[0]["lat"].to_f,
      lng: json[0]["lon"].to_f,
    }
    return coord
  end

  def reverse_geo(lat, lng)
    uri = URI("https://geocode.maps.co/reverse?lat=#{lat}&lon=#{lng}")
    pp uri
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    pp json
    address = json["address"]
    pp address
    return address
  end
end
