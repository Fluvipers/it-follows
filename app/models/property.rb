class Property < ActiveRecord::Base
  PROPERTIES_TYPES = %w( String Date Integer Decimal Boolean)
  belongs_to :line
  validates_presence_of :name
  validates_inclusion_of :data_type, in: PROPERTIES_TYPES
end
