class Api::V1::ReportsController < ApplicationController
  before_action :set_report, only: [:show, :destroy] 

  def index
    reports = Report.all.order(created_at: :desc).limit(20)
    render json: reports
  end

  def create
    report = Report.create!(report_params)
    if report
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
    params.permit(:address_street, :address_zip, :category, :description, :lat, :lon, :reporter_id, :neighborhood, :suburb, :created_at)
  end

  def set_report
    @report = Report.find(params[:id])
  end
end
