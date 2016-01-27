class ReadingsController < ApplicationController
  before_action :set_reading, only: [:show, :update, :destroy]

  # GET /readings
  # GET /readings.json
  def index
    @readings = Reading.all

    render json: @readings
  end

  # GET /readings/1
  # GET /readings/1.json
  def show
    render json: @reading
  end

  # POST /readings
  # POST /readings.json
  def create
    @reading = Reading.new(reading_params)

    if @reading.save
      render json: @reading, status: :created, location: @reading
    else
      render json: @reading.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /readings/1
  # PATCH/PUT /readings/1.json
  def update
    @reading = Reading.find(params[:id])

    if @reading.update(reading_params)
      head :no_content
    else
      render json: @reading.errors, status: :unprocessable_entity
    end
  end

  # DELETE /readings/1
  # DELETE /readings/1.json
  def destroy
    @reading.destroy

    head :no_content
  end

  private

    def set_reading
      @reading = Reading.find(params[:id])
    end

    def reading_params
      params.require(:reading).permit(:start_date, :end_date, :date_range)
    end
end
