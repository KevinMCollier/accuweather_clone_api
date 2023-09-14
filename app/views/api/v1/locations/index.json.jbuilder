json.array! @locations do |location|
  json.extract! location, :id, :name, :latitude, :longitude
end
