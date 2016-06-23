require 'openssl'
require 'geokit'

class GeoLocator
  include Sidekiq::Worker

  def perform(link_click_id)
    click = LinkClick.find(link_click_id)

    location = Geokit::Geocoders::FreeGeoIpGeocoder.geocode(click.ip)
    country = ISO3166::Country.new(location.country_code)

    logger.info "Location for #{click.ip} => {lat => #{location.lat}, lng => #{location.lng}, country => #{country.name} }"

    click.lat = location.lat
    click.lng = location.lng
    click.country = country.name

    click.save
  end

end