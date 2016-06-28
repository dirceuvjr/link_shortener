class Link < ActiveRecord::Base
  belongs_to :user

  has_many :link_clicks, :dependent => :delete_all
  has_many :link_click_counts, :dependent => :delete_all

  after_create :generate_slug, :scrape_url

  validates_presence_of :url
  validates_format_of :url, :with => /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/

  def display_slug
    ENV['BASE_URL'] + self.slug
  end

  def to_param
    self.slug
  end

  private
  def generate_slug
    require 'base64'
    require 'openssl'
    self.slug = Base64.urlsafe_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), "#{self.user.id}", "#{self.id}")).strip()[0..7]
    self.save
  end

  def scrape_url
    Scrape.perform_async(self.id)
  end

end
