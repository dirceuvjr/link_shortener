class LinksController < ApplicationController

  before_action :set_link, :only => [:show, :edit, :destroy]

  before_filter :authenticate_user!, :except => [:new, :process_slug]

  geocode_ip_address :only => :process_slug

  # GET /:slug
  def process_slug
    @link = Link.find_by_slug(params[:slug])

    respond_to do |format|
      format.html {
        if redirect_to @link.url

          user_agent_string = request.headers['User-Agent']
          ua = AgentOrange::UserAgent.new(user_agent_string)

          click = LinkClick.new
          click.ip = request.remote_ip
          click.lat = session[:geo_location].lat if session[:geo_location]
          click.lng = session[:geo_location].lng if session[:geo_location]

          click.device = ua.device.name

          click.platform = ua.device.platform.name
          click.platform_version = ua.device.platform.version

          click.operating_system = ua.device.operating_system.name
          click.operating_system_version = ua.device.operating_system.version

          click.engine = ua.device.engine.name
          click.engine_version = ua.device.engine.version

          click.browser = ua.device.engine.browser.name
          click.browser_version = ua.device.engine.browser.version

          click.save!

        end
      }
    end

  end

  # GET /links
  # GET /links.json
  def index
    @links = current_user.links
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)
    @link.user = current_user

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, :notice => 'Link was successfully created.' }
        format.json { render :show, :status => :created, :location => @link }
      else
        format.html { render :new }
        format.json { render :json => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, :notice => 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def link_params
    params.require(:link).permit(:url)
  end
end
