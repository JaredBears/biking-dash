class BluIteratorsController < ApplicationController
  before_action :set_blu_iterator, only: %i[ show edit update destroy ]

  # GET /blu_iterators or /blu_iterators.json
  def index
    @blu_iterators = BluIterator.all
  end

  # GET /blu_iterators/1 or /blu_iterators/1.json
  def show
  end

  # GET /blu_iterators/new
  def new
    @blu_iterator = BluIterator.new
  end

  # GET /blu_iterators/1/edit
  def edit
  end

  # POST /blu_iterators or /blu_iterators.json
  def create
    @blu_iterator = BluIterator.new(blu_iterator_params)

    respond_to do |format|
      if @blu_iterator.save
        format.html { redirect_to blu_iterator_url(@blu_iterator), notice: "Blu iterator was successfully created." }
        format.json { render :show, status: :created, location: @blu_iterator }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blu_iterator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blu_iterators/1 or /blu_iterators/1.json
  def update
    respond_to do |format|
      if @blu_iterator.update(blu_iterator_params)
        format.html { redirect_to blu_iterator_url(@blu_iterator), notice: "Blu iterator was successfully updated." }
        format.json { render :show, status: :ok, location: @blu_iterator }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blu_iterator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blu_iterators/1 or /blu_iterators/1.json
  def destroy
    @blu_iterator.destroy

    respond_to do |format|
      format.html { redirect_to blu_iterators_url, notice: "Blu iterator was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blu_iterator
      @blu_iterator = BluIterator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blu_iterator_params
      params.fetch(:blu_iterator, {})
    end
end
