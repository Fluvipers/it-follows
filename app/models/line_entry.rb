class LineEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :line

  has_many :followups
  has_many :tasks, through: :followups

  accepts_nested_attributes_for :followups

  def current_percentage
    followups.last.try(:percentage).to_i
  end

  def needs_followup?
    current_percentage < 100
  end
end
