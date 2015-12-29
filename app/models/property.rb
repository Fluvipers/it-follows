class Property < ActiveRecord::Base
  belongs_to :line
  validates_presence_of :line_id, :name
end
