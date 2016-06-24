class ChartsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :set_link

  def index
    redirect_to link_chart_path(:chart => :overall)
  end

  def show
    chart = params[:chart]
    redirect_to root_path and return unless valid?(chart) # TODO: redirect to error page
    respond_to do |format|
      format.html { render chart and return }
      format.json { render :json => chart_data(chart) }
    end
  end

  private
  def set_link
    @link = current_user.links.find_by_slug(params[:link_id])
  end

  def valid?(chart)
    %w[browser country operating_system device overall].include?(chart)
  end

  def chart_data(type)
    if type === 'overall'
      @link.link_click_counts.where(:agg_type => type).group_by_day(:date).sum(:count)
    else
      @link.link_click_counts.where(:agg_type => type).group(:name).sum(:count)
    end
  end

end