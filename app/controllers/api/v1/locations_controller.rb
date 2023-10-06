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
    temperature = weather_data['main']['temp']

    current_time_utc = Time.now.getutc

    timezone_offset = weather_data['timezone']
    local_time = current_time_utc + timezone_offset

    sunrise_time = Time.at(weather_data['sys']['sunrise']).getutc
    sunset_time = Time.at(weather_data['sys']['sunset']).getutc
    time_of_day = (sunrise_time..sunset_time).cover?(local_time) ? 'daytime' : 'nighttime'

    prompt = <<~PROMPT
      Create a haiku for a weather app that is funny, engaging, and reflective of the current weather condition.

      Weather Condition: #{weather_description}
      Temperature: #{temperature}
      Time of Day: #{time_of_day}
      Location: #{searched_name}

      The haiku should:
      - Reflect the tone and mood associated with the weather condition, temperature, and/or time of day.
      - Mention or allude to the location (#{searched_name}).
      - Follow the traditional 5-7-5 syllable format.


      Format the output as a JSON object with these attributes and this format. Weather_data and searched_name are already provided.

      "weather_data" : #{weather_description},
      "searched_name" : #{searched_name},
      "line_1" : "line_1",
      "line_2" : "line_2",
      "line_3" : "line_3"
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
