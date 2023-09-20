class Api::V1::LocationsController < Api::V1::BaseController
  before_action :set_location, only: %i[show destroy]

  def index
    @locations = policy_scope(Location)
    # render json: @locations
  end

  def show
    weather_service = OpenWeatherService.new(@location.name)
    @weather_data = weather_service.fetch_weather
    puts @weather_data
    # If you also want the forecast:
    @forecast_data = weather_service.fetch_forecast
    # render json: @weather_data
    # render json: @forecast_data
  end

  def update
    if @location.update(location_params)
      render :show
    else
      render_error
    end
  end

  def create
    @location = Location.new(location_params)
    @location.user = current_user
    authorize @location
    if @location.save
      render :show, status: :created
    else
      render_error
    end
  end

  def destroy
    @location.destroy
    head :no_content
  end

  def search
    authorize Location, :search?
    weather_service = OpenWeatherService.new(params[:query])
    @weather_data = weather_service.fetch_weather
  end

  private

  def location_params
    params.require(:location).permit(:name, :latitude, :longitude)
  end

  def set_location
    @location = Location.find(params[:id])
    authorize @location
  end

  def render_error
    render json: { errors: @location.errors.full_messages }, status: :unprocessable_entity
  end
end
