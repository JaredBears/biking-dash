class ReportedCarsController < ApplicationController
  before_action :set_reported_car, only: %i[ show edit update destroy ]

  # GET /reported_cars or /reported_cars.json
  def index
    @reported_cars = ReportedCar.all
  end

  # GET /reported_cars/1 or /reported_cars/1.json
  def show
  end

  # GET /reported_cars/new
  def new
    @reported_car = ReportedCar.new
  end

  # GET /reported_cars/1/edit
  def edit
  end

  # POST /reported_cars or /reported_cars.json
  def create
    @reported_car = ReportedCar.new(reported_car_params)

    respond_to do |format|
      if @reported_car.save
        format.html { redirect_to reported_car_url(@reported_car), notice: "Reported car was successfully created." }
        format.json { render :show, status: :created, location: @reported_car }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reported_car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reported_cars/1 or /reported_cars/1.json
  def update
    respond_to do |format|
      if @reported_car.update(reported_car_params)
        format.html { redirect_to reported_car_url(@reported_car), notice: "Reported car was successfully updated." }
        format.json { render :show, status: :ok, location: @reported_car }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reported_car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reported_cars/1 or /reported_cars/1.json
  def destroy
    @reported_car.destroy

    respond_to do |format|
      format.html { redirect_to reported_cars_url, notice: "Reported car was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reported_car
      @reported_car = ReportedCar.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reported_car_params
      params.require(:reported_car).permit(:car_id, :report_id)
    end
end
