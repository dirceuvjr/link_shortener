class LinksController < ApplicationController

  before_action :set_link, :only => [:destroy]

  before_filter :authenticate_user!, :except => [:new, :process_slug]

  # GET /:slug
  def process_slug
    @link = Link.find_by_slug(params[:slug])

    redirect_to page_path(:id => 'not_found') and return if @link.nil? or @link.url.nil?

    respond_to do |format|
      format.html {
        if redirect_to @link.url

          user_agent_string = request.headers['User-Agent']
          ua = AgentOrange::UserAgent.new(user_agent_string)

          click = LinkClick.new
          click.ip = request.env["HTTP_X_FORWARDED_FOR"].try(:split, ',').try(:last) || request.env["REMOTE_ADDR"]
          click.link = @link

          unless ua.nil? || ua.device.nil?
            click.device = ua.device.name unless ua.device.name.nil?

            click.platform = ua.device.platform.name unless ua.device.platform.nil? || ua.device.platform.name.nil?
            click.platform_version = ua.device.platform.version unless ua.device.platform.nil? || ua.device.platform.version.nil?

            unless ua.device.operating_system.nil?
              click.operating_system = ua.device.operating_system.name unless ua.device.operating_system.name.nil?
              click.operating_system_version = ua.device.operating_system.version unless ua.device.operating_system.version.nil?
            end

            unless ua.device.engine.nil?
              click.engine = ua.device.engine.name unless ua.device.engine.name.nil?
              click.engine_version = ua.device.engine.version unless ua.device.engine.version.nil?

              unless ua.device.engine.browser.nil?
                click.browser = ua.device.engine.browser.name unless ua.device.engine.browser.name.nil?
                click.browser_version = ua.device.engine.browser.version unless ua.device.engine.browser.version.nil?
              end
            end
          end

          click.save!

          GeoLocator.perform_async(click.id)
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
      if verify_recaptcha(:model => @link) && @link.save
        format.html {
          ClickCountAggregator.perform_async(@link.id)
          redirect_to links_url, :notice => 'Link was successfully created.'
        }
      else
        format.html {
          flash[:error] = @link.errors.full_messages
          render :new
        }
      end
    end
  end

  # DELETE /links/:slug
  # DELETE /links/:slug.json
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
    @link = Link.find_by_slug(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def link_params
    params.require(:link).permit(:url)
  end
end
