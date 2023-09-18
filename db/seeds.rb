# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "First, let's clean up..."
# Forecast.destroy_all
Location.destroy_all
User.destroy_all

puts "It's alive, it's alive!!!!"
# Create some Users
user1 = User.create(email: "john.doe@example.com", password: "password123", password_confirmation: "password123")
user2 = User.create(email: "jane.doe@example.com", password: "password123", password_confirmation: "password123")

# Create some Locations associated with users
puts "It's alive and their address is..."
Location.create(name: "Tokyo", latitude: 35.6895, longitude: 139.6917, user: user1)
Location.create(name: "Yokohama", latitude: 35.4437, longitude: 139.6380, user: user2)
Location.create(name: "Sapporo", latitude: 43.0618, longitude: 141.3545, user: user1)
# # Create some Forecasts associated with locations and users
# puts "The weather is..."
# Forecast.create(temperature: 21.5, condition: "Sunny", location: location1, user: user1)
# Forecast.create(temperature: 25.0, condition: "Cloudy", location: location2, user: user2)
# Forecast.create(temperature: 18.0, condition: "Rainy", location: location3, user: user1)

puts "Seeds created successfully!"
