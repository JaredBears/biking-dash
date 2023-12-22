class WhuService

  def initialize
    @url = "https://whitehouseuprising.github.io/maps2/data/chicago/all.json"
    @starting = 0
    @ending = 0
    @new_reports = {}
  end

  def import_whu_data()
    uri = URI("https://whitehouseuprising.github.io/maps2/data/chicago/all.json")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)

    json.sort_by! { |report| report.dig("properties", "id") }
    @ending = json.last.dig("properties", "id")

    first_index = json.find_index { |report| report.dig("properties", "id") == @starting }
    json = json[first_index..-1]
    json.each do |report|
      pp "adding report #{[report.dig("properties", "id")]} to new_reports..."
      if report.dig("properties", "obstruction")[0..4] == "Other"
        report.dig("properties", "obstruction")[0..-1] = "Other  (damaged lane / snow / debris / pedestrian / etc.)"
      end
      @new_reports["reports"][report.dig("properties", "id")] = {
        blu_id: report.dig("properties", "id"),
        category: report.dig("properties", "obstruction"),
        lat: report.dig("geometry", "coordinates")[1],
        lon: report.dig("geometry", "coordinates")[0],
      }
      pp "#{@new_reports["reports"][report.dig("properties", "id")]} added"
    end
    if Rails.env.development?
      pp "saving new_reports to json file..."
      File.open("new_reports#{Date.Today}.json", "w") do |f|
        f.write(@new_reports.to_json)
      end
    end
  end
  
end
