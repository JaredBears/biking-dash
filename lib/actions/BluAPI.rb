#Create BluAPI class which will retrieve JSON files from the BLU API

require 'net/http'
require 'json'

class BluAPI

  #Initialize the class with the URL to the BLU API
  def initialize(url)
    @blu_url = "https://feed.bikelaneuprising.com/api/feed"
    @whu_url = "https://whitehouseuprising.github.io/maps2/data/chicago/all.json"
  end

  #Get the JSON file from the BLU API and add each report to the database if not already added
  def get_blu_json
    uri = URI(@blu_url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    pp json
  end

end
