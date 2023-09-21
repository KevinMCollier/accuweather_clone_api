# json.extract! @location, :name, :latitude, :longitude

json.city_name params[:query]
json.timezone @weather_data['timezone']

json.set! :weather do
  json.temperature @weather_data['main']['temp'].round
  json.temp_min @weather_data['main']['temp_min'].round
  json.temp_max @weather_data['main']['temp_max'].round
  json.humidity @weather_data['main']['humidity']
  json.feels_like @weather_data['main']['feels_like'].round
  json.description @weather_data['weather'][0]['description'].capitalize
  json.icon @weather_data['weather'][0]['icon']
  json.searched_name @searched_name
end
