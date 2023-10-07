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
    @searched_name = params[:query]

    prompt = build_prompt(@weather_data, @searched_name)
    @haiku = get_haiku(prompt)
  end

  def forecast
    authorize Location, :search?
    weather_service = OpenWeatherService.new(params[:query])
    @forecast_data = weather_service.fetch_forecast
    @searched_name = params[:query]
    render json: @forecast_data
    # can replace the line above if creating a forecast.json.jbuilder file
    puts @forecast_data
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

  def build_prompt(weather_data, searched_name)
    weather_description = weather_data['weather'][0]['description']
    # temperature = weather_data['main']['temp']

    current_time_utc = Time.now.getutc

    timezone_offset = weather_data['timezone']
    local_time = current_time_utc + timezone_offset

    sunrise_time = Time.at(weather_data['sys']['sunrise']).getutc
    sunset_time = Time.at(weather_data['sys']['sunset']).getutc
    time_of_day = (sunrise_time..sunset_time).cover?(local_time) ? 'daytime' : 'nighttime'

    prompt = <<~PROMPT
      Create a haiku for a weather app that is engaging and reflective of the current weather.

      Requirements:
      - The haiku should reflect the tone and mood associated with the current weather: #{weather_description}
      - The haiku should take time of day should also into consideration: #{time_of_day}
      - The haiku should mention or allude to the location: #{searched_name}.
      - The haiku should be written in Japanese.
      - The haiku should follow the traditional 5-7-5 syllable format.
      - An English transaltion of the haiku should also be provided


      Format the output as a JSON object with these attributes and this format.

      "weather_data" : #{weather_description},
      "searched_name" : #{searched_name},
      "line_1_jp" : "line_1 in Japanese",
      "line_2_jp" : "line_2 in Japanese",
      "line_3_jp" : "line_3 in Japanese",
      "line_1_en" : "line_1 in English",
      "line_2_en" : "line_2 in English",
      "line_3_en" : "line_3 in English",
    PROMPT
    puts "Generated Prompt: #{prompt}"
    return prompt
  end

  def get_haiku(prompt)
    openai_service = OpenaiService.new(prompt)
    response = openai_service.call
    haiku = response['choices'][0]['message']['content']
    begin
      haiku = JSON.parse(haiku)
    rescue JSON::ParserError
      render :new, notice: "Try again"
    end
    p haiku
    return haiku
  end
end
