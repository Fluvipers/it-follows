class Dashboard < ActiveRecord::Base
  belongs_to :line
  validates_presence_of :dashboard_url
  validates_presence_of :dashboard_name
end
