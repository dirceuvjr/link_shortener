desc 'Populates geo location data in LinkClick\'s where those values are nil'
task :populate_geo_loc => :environment do

  LinkClick.where('lat is null or lng is null or country is null').each do |click|
    GeoLocator.perform_async(click.id)
  end

end

desc 'Aggregates click count by date and type'
task :aggregate_click_count => :environment do

  date = ENV['DATE']

  puts "Aggregates click count by date (#{date}) and type."

  Link.all.each do |link|
    if date.nil? || date.empty?
      ClickCountAggregator.perform_async(link.id)
    else
      ClickCountAggregator.perform_async(link.id, date)
    end
  end

end