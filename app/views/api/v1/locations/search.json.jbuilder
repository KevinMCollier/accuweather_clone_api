# json.extract! @location, :name, :latitude, :longitude

json.city_name params[:query]
json.country @weather_data['sys']['country']
json.timezone @weather_data['timezone']
json.sunrise @weather_data['sys']['sunrise']
json.sunset @weather_data['sys']['sunset']

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

json.set! :haiku do
  json.line_1_jp @haiku['line_1_jp']
  json.line_2_jp @haiku['line_2_jp']
  json.line_3_jp @haiku['line_3_jp']
  json.line_1_en @haiku['line_1_en']
  json.line_2_en @haiku['line_2_en']
  json.line_3_en @haiku['line_3_en']
end
