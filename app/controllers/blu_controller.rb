# I think this should be refactored into separate white house uprising and bike lane uprising "service objects"
# That way your controllers can stay lean
# https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial

class BluController < ApplicationController

  #This controller is to coordinate with the different endpoints for the blu
  #api.  The first endpoint (whu), displays a list of ALL chicago incidents.
  #The second endpoint (blu), displays a paginated list of incidents for all
  #locations.
  #When I begin importing data, it will check the database for the most recent
  #blu_id, and then discard all previous incidents.  It will then save all
  #incidents from the whu endpoint to hash object before proceeding to the
  #second endpoint.  It will then iterate through the pages, adding the
  #relevant information to the existing hash entries.
  #It will periodically save all new reports to a json file in case the
  #importing process is interrupted.
  #Once all the data has been imported, it will iterate through the hash
  #and add the relevant information to the database.
  #It also has random waits added in to avoid hitting the API too hard.

  def initialize
    @geo = GeoencoderController.new
    @starting = 0
    @ending = 0
    @new_reports = {}
  end

  def import_data_all
    initial_count = Report.count
    @starting = initial_count == 0 ? 6000 : Report.order(blu_id: :desc).first.blu_id
    import_whu_data
    import_blu_data
    synchronize_data
  end

  private

  def synchronize_data
    pp "synchronizing data..."
    pp "starting at #{@starting} and ending at #{@ending}"
    @new_reports["reports"].each do |blu_id, report|
      pp report
      pp "Syncing blu_report #{blu_id}..."
      r = Report.create({
        blu_id: blu_id,
        category: report[:category],
        lat: report[:lat],
        lon: report[:lon],
        created_at: report[:created_at],
        address_street: report[:address_street],
        address_zip: report[:address_zip],
        neighborhood: report[:neighborhood],
        suburb: report[:suburb],
        reporter_id: report[:reporter_id],
      })
      report[:images].each do |image|
        if image[-3..-1] == "png"
          next
        end
        pp "adding image #{image} to report #{r.id}..."
        r.images.attach(io: URI.open(image), filename: "#{r.id}")
        sleep(rand(1..5))
      end
      r.save!
    end
  end
end
