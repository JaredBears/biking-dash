class Api::V1::ReportsController < ApplicationController
  before_action :set_report, only: [:show, :destroy] 
  before_action :set_geo, only: [:create]
  # permit params


  def index
    reports = Report.all.order(created_at: :desc).limit(20)
    render json: reports
  end

  def create
    report = Report.create!(report_params)
    if report
      if (report.lat.nil? || report.lon.nil?) && !report.address_street.nil?
        coord = @geo.geocode(report.address_street, report.address_zip)
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
        report.save!
      end
        
      render json: report
    else
      render json: report.errors
    end
  end

  def show
    pp params[:id]
    if @report
      render json: @report
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
    params.require(:report).permit(:category, :lat, :lon, :address_street, :address_zip, :description, :reporter_id)
  end

  def set_report
    @report = Report.find(params[:id])
  end

  def set_geo
    @geo = GeoencoderController.new
  end
end
