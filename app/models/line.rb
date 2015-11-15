class Line < ActiveRecord::Base
  belongs_to :user
  has_many :line_entries, dependent: :destroy
end
