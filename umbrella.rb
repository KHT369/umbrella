require "dotenv/load"
require "http"
require "json"
GMAPS_KEY = ENV.fetch("GMAPS_KEY")
PIRATE_WEATHER_KEY = ENV.fetch("PIRATE_WEATHER_KEY")
#gem install http in bash
puts "======================================= Will You Need An Umbrealla Today? ======================================="

pp "Where are you?"
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
temperature = parsed_response_pirate.fetch("currently").fetch("temperature")

pp "It is currently" + temperature.to_s + "°F"
pp "Next hour:" + weather.to_s 
if weather == " Clear"
  pp "You probably won't need an umbrella"
elsif weather != "Clear"
  pp "In the next 1 hours, there is a " + weather.fetch("hourly").fetch("data").at(1).fetch("perceipProbability").to_s + "% chance of percipitation"
  pp "In the next 2 hours, there is a " + weather.fetch("hourly").fetch("data").at(2).fetch("perceipProbability").to_s + "% chance of percipitation"
  pp "You might want to take an umbrella"
end
