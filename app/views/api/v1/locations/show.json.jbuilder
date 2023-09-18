json.extract! @location, :name, :latitude, :longitude

json.set! :weather do
  json.temperature @weather_data['main']['temp']
  json.temp_min @weather_data['main']['temp_min']
  json.temp_max @weather_data['main']['temp_max']
  json.humidity @weather_data['main']['humidity']
  json.feels_like @weather_data['main']['feels_like']
  json.description @weather_data['weather'][0]['description']
  json.icon @weather_data['weather'][0]['icon']
end
