json.extract! @location, :name, :latitude, :longtitude
json.weather @weather_data do |weather|
  json.extract! weather, :temperature, :condition
end
