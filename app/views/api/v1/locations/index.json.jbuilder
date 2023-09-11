json.array! @locations do |location|
  json.extract! restaurant, :id, :name, :address
end
