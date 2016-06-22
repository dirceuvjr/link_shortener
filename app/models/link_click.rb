class LinkClick < ActiveRecord::Base
  belongs_to :link
  acts_as_mappable
end
