class ClickCountAggregator
  include Sidekiq::Worker

  def perform(link_id, date = nil)
    @link = Link.find(link_id)
    @date = date.nil? || date.empty? ? Date.yesterday : Date.parse(date)

    aggregate(:browser)
    aggregate(:device)
    aggregate(:platform)
    aggregate(:operating_system)
    aggregate(:engine)
    aggregate(:country)
    aggregate(:overall)

    logger.info "ClickCountAggregator.perform(#{@link.id}, #{@date})"

  end

  private

  def aggregate(type)
    get_aggregated_clicks(type).each {|name, count| create_link_click_count(type, name, count)}
  end

  def get_aggregated_clicks(type)
    if type === :overall
      {'' => @link.link_clicks.where(['created_at between ? and ?', @date.beginning_of_day, @date.end_of_day]).count}
    else
      @link.link_clicks.where(["#{type} is not null and created_at between ? and ?", @date.beginning_of_day, @date.end_of_day]).group(type).count
    end
  end

  def create_link_click_count(type, name, count)
    lcc = LinkClickCount.where(:agg_type => type, :name => name, :date => @date, :link => @link).first_or_create
    lcc.count = count

    lcc.save!
  end

end