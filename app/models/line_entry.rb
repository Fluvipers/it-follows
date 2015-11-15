class LineEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :line

  validates_presence_of :data
end
