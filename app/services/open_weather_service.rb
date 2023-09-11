require 'open-uri'
require 'json'

class OpenWeatherService
  BASE_URL = 'http://api.openweathermap.org/data/2.5'

  def initialize(city)
    @city = city
  end

  def fetch_weather
    response = URI.open("#{BASE_URL}/weather?q=#{@city}&appid=#{ENV['OPEN_WEATHER_MAP_API_KEY']}&units=metric").read
    JSON.parse(response)
  rescue OpenURI::HTTPError => e
  end

  def fetch_forecast
    response = URI.open("#{BASE_URL}/forecast?q=#{@city}&appid=#{ENV['OPEN_WEATHER_MAP_API_KEY']}&units=metric").read
    JSON.parse(response)
  end
end
