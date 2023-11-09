class ReportedBikesController < ApplicationController
  before_action :set_reported_bike, only: %i[ show edit update destroy ]

  # GET /reported_bikes or /reported_bikes.json
  def index
    @reported_bikes = ReportedBike.all
  end

  # GET /reported_bikes/1 or /reported_bikes/1.json
  def show
  end

  # GET /reported_bikes/new
  def new
    @reported_bike = ReportedBike.new
  end

  # GET /reported_bikes/1/edit
  def edit
  end

  # POST /reported_bikes or /reported_bikes.json
  def create
    @reported_bike = ReportedBike.new(reported_bike_params)

    respond_to do |format|
      if @reported_bike.save
        format.html { redirect_to reported_bike_url(@reported_bike), notice: "Reported bike was successfully created." }
        format.json { render :show, status: :created, location: @reported_bike }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reported_bike.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reported_bikes/1 or /reported_bikes/1.json
  def update
    respond_to do |format|
      if @reported_bike.update(reported_bike_params)
        format.html { redirect_to reported_bike_url(@reported_bike), notice: "Reported bike was successfully updated." }
        format.json { render :show, status: :ok, location: @reported_bike }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reported_bike.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reported_bikes/1 or /reported_bikes/1.json
  def destroy
    @reported_bike.destroy

    respond_to do |format|
      format.html { redirect_to reported_bikes_url, notice: "Reported bike was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reported_bike
      @reported_bike = ReportedBike.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reported_bike_params
      params.require(:reported_bike).permit(:bike_id, :report_id)
    end
end
