require "dotenv/load"
require "http"
require "json"
GMAPS_KEY = ENV.fetch("GMAPS_KEY")
PIRATE_WEATHER_KEY = ENV.fetch("PIRATE_WEATHER_KEY")
#gem install http in bash
puts "=======================================\n   Will You Need An Umbrealla Today?\n======================================="
puts ""
puts "Where are you?"
location = gets.chomp
pp "Checking the weather at " + location.to_s
google_maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + location + "&key=" + GMAPS_KEY

raw_response_gmap = HTTP.get(google_maps_url)
parsed_response_gmap = JSON.parse(raw_response_gmap)

loc = parsed_response_gmap.fetch("results").at(0)
latitude = loc.fetch("geometry").fetch("location").fetch("lat")
longitude = loc.fetch("geometry").fetch("location").fetch("lng")

pp "Your coordinates are " + latitude.to_s + ", " + longitude.to_s

pirate_weather_url = "https://api.pirateweather.net/forecast/" + PIRATE_WEATHER_KEY + "/" + latitude.to_s + ", " + longitude.to_s

raw_response_pirate = HTTP.get(pirate_weather_url)
parsed_response_pirate = JSON.parse(raw_response_pirate)
weather = parsed_response_pirate.fetch("hourly").fetch("summary")
weather1 = parsed_response_pirate.fetch("hourly").fetch("data")

temperature = parsed_response_pirate.fetch("currently").fetch("temperature")

pp "It is currently " + temperature.to_s + "°F"
pp "Next hour: " + weather.to_s 

if weather == "Clear"
  pp "You probably won't need an umbrella"
elsif weather != "Clear"
  puts "In the next 1 hours, there is a " + (weather1.at(1).fetch("precipProbability") * 100).to_s + "% chance of precipitation"
  puts "In the next 2 hours, there is a " + (weather1.at(2).fetch("precipProbability") * 100).to_s + "% chance of precipitation"
    if weather1.at(2).fetch("precipProbability")*100 < 10
      puts "You probably won't need an umbrella"
    else 
      puts "You might want to take an umbrella"
    end
end
# I can just end without the else
