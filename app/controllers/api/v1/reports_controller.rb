class Api::V1::ReportsController < ApplicationController
  before_action :set_report, only: [:show, :destroy] 
  before_action :set_geo, only: [:create]
  # permit params

  include Rails.application.routes.url_helpers


  def index
    reports = Report.all.order(created_at: :desc).limit(20)
    render json: reports.map { |report|
      {
        "id": report.id,
        "category": report.category,
        "image": report.images[0].nil? ? "" : report.images[0].blob.attributes.slice("id").merge(url: url_for(report.images[0]))[:url],
        "lat": report.lat,
        "lon": report.lon,
      }
    }
  end

  def create
    params = report_params
    report = Report.new(params)
    pp report_params
    
    if report
      if (report.lat.nil? || report.lon.nil?) && !report.address_street.nil?
        coord = @geo.geo_encode(report.address_street + " " + "Chicago, IL " + report.address_zip)
        report.lat = coord[:lat]
        report.lon = coord[:lon]
        report.save!
      end
      if(!report.lat.nil? && !report.lon.nil?)
        address_info = @geo.reverse_geo(report.lat, report.lon)
        if address_info.nil?
          address_info = {
            "house_number" => "",
            "road" => "",
            "postcode" => "",
            "neighbourhood" => "",
            "suburb" => "",
          }
        end
        report.address_street = "#{address_info["house_number"]} #{address_info["road"]}"
        report.address_zip = address_info["postcode"]
        report.neighborhood = address_info["neighbourhood"]
        report.suburb = address_info["suburb"]
        report.description = params[:description]
        report.save!
        pp params[:description]
        pp report.description
        pp report_params[:description]
      end
      render json: report
    else
      render json: report.errors
    end
  end

  def show
    pp params[:id]
    if @report
      @images = []
      @report.images.each do |image|
        @images.push(image.blob.attributes.slice("id").merge(url: url_for(image))[:url])
      end
      render json: {
        "id": @report.id,
        "category": @report.category,
        "lat": @report.lat,
        "lon": @report.lon,
        "address_street": @report.address_street,
        "address_zip": @report.address_zip,
        "neighborhood": @report.neighborhood,
        "suburb": @report.suburb,
        "images": @images.join("|"),
        "reporter_id": @report.reporter_id,
        "created_at": @report.created_at,
        "description": @report.description,
  }
    else
      render json: @report.errors
    end
  end

  def destroy
    @report&.destroy
    render json: { message: 'Report deleted!' }
  end

  private

  def report_params
    params.require(:report).permit(:category, :lat, :lon, :address_street, :address_zip, :description, :reporter_id, :images => [])
  end

  def set_report
    @report = Report.find(params[:id])
  end

  def set_geo
    @geo = GeoencoderController.new
  end
end
