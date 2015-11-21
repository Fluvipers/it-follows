class LineEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :line

  has_many :followups
  has_many :tasks, through: :followups

  accepts_nested_attributes_for :followups
end
