class Task < ActiveRecord::Base
  belongs_to :followup
  belongs_to :user
  validates_presence_of :description
end
