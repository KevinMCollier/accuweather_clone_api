json.extract! @location, :name, :latitude, :longitude
json.weather @weather_data do |weather|
  json.extract! weather, :temperature, :condition
end
