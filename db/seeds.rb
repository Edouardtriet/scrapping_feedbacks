# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
puts "Clearing database..."
App.destroy_all

# Create sample apps
puts "Creating sample apps..."
App.create!(
  name: "WhatsApp",
  developer: "Meta Platforms, Inc.",
  icon_url: "https://play-lh.googleusercontent.com/bYtqbOcTYOlgc6gqZ2rwb8lptHuwlNE75zYJu6Bn076-hTmvd96HH-6v7S0YUAAJXoJN=w240-h480-rw",
  platform: "android"
)

App.create!(
  name: "Instagram",
  developer: "Meta Platforms, Inc.",
  icon_url: "https://play-lh.googleusercontent.com/VRMWkE5p3CkWhJs6nv-9ZsLAs1QOg5ob1_3qg-rckwYW7yp1fMrYZqnEFpk0IoVP4LM=w240-h480-rw",
  platform: "android"
)

App.create!(
  name: "Telegram",
  developer: "Telegram FZ-LLC",
  icon_url: "https://play-lh.googleusercontent.com/ZU9cSsyIJZo6Oy7HTHiEPwZg0m2Crep-d5ZrfajqtsH-qgUXSqKpNA2FpPDTn-7qA5Q=w240-h480-rw",
  platform: "android"
)

puts "Created #{App.count} apps"
