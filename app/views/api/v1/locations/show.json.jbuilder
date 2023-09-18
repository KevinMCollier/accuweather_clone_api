json.extract! @location, :name, :latitude, :longitude

json.set! :weather do
  json.temperature @weather_data['main']['temp'].round
  json.temp_min @weather_data['main']['temp_min'].round
  json.temp_max @weather_data['main']['temp_max'].round
  json.humidity @weather_data['main']['humidity']
  json.feels_like @weather_data['main']['feels_like'].round
  json.description @weather_data['weather'][0]['description']
  json.icon @weather_data['weather'][0]['icon']
end
