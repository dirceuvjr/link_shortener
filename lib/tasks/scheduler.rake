desc 'Populate geo location data in LinkClick\'s where those values are nil'
task :populate_geo_loc => :environment do

  LinkClick.where(:lat => nil, :lng => nil, :country => nil).each do |click|
    GeoLocator.perform_async(click.id)
  end

end