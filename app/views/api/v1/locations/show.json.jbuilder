json.extract! @location, :id, :name, :address
json.comments @location.forecasts do |forecast|
  json.extract! forecast, :temperature, :condition
end
