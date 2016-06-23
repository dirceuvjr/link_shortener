require 'openssl'
require 'geokit'

class GeoLocator
  include Sidekiq::Worker

  def perform(link_click_id)
    click = LinkClick.find(link_click_id)

    location = Geokit::Geocoders::FreeGeoIpGeocoder.geocode(click.ip)
    puts "Location for #{click.ip} => {lat => #{location.lat}, lng => #{location.lng} }"
    click.lat = location.lat
    click.lng = location.lng
    click.country = location.country

    click.save
  end

end