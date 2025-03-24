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
  apple_id: "310633997",
  google_id: "com.whatsapp",
)

App.create!(
  name: "Spotify",
  apple_id: "324684580",
  google_id: "com.spotify.music",
)

App.create!(
  name: "Facebook",
  apple_id: "284882215",
  google_id: "com.facebook.katana",
)

App.create!(
  name: "TikTok",
  apple_id: "835599320",
  google_id: "com.zhiliaoapp.musically",
)

App.create!(
  name: "Netflix",
  apple_id: "363590051",
  google_id: "com.netflix.mediaclient",
)

App.create!(
  name: "Twitter",
  apple_id: "333903271",
  google_id: "com.twitter.android",
)

App.create!(
  name: "Pinterest",
  apple_id: "429047995",
  google_id: "com.pinterest",
)

puts "Created #{App.count} apps"
