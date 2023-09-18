# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "First, let's clean up..."
Forecast.destroy_all
Location.destroy_all
User.destroy_all

puts "It's alive, it's alive!!!!"
# Create some Users
user1 = User.create(email: "john.doe@example.com", password: "password123", password_confirmation: "password123")
user2 = User.create(email: "jane.doe@example.com", password: "password123", password_confirmation: "password123")

# Create some Locations associated with users
puts "It's alive and their address is..."
location1 = Location.create(name: "New York", latitude: 40.7128, longitude: -74.0060, user: user1)
location2 = Location.create(name: "Los Angeles", latitude: 34.0522, longitude: -118.2437, user: user2)
location3 = Location.create(name: "Chicago", latitude: 41.8781, longitude: -87.6298, user: user1)

# # Create some Forecasts associated with locations and users
# puts "The weather is..."
# Forecast.create(temperature: 21.5, condition: "Sunny", location: location1, user: user1)
# Forecast.create(temperature: 25.0, condition: "Cloudy", location: location2, user: user2)
# Forecast.create(temperature: 18.0, condition: "Rainy", location: location3, user: user1)

puts "Seeds created successfully!"
