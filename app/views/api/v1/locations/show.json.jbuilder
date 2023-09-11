json.extract! @location, :name, :latitude, :longtitude
json.comments @location.forecasts do |forecast|
  json.extract! forecast, :temperature, :condition
end
