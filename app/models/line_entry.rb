class LineEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :line

  has_many :followups, dependent: :destroy
  has_many :tasks, through: :followups

  accepts_nested_attributes_for :followups
  validates_presence_of :data
  validate :validation_parameters
  before_save :validation_parameters

  def current_percentage
    followups.last.try(:percentage).to_i
  end

  def needs_followup?
    current_percentage < 100
  end

  def validation_parameters
    number_params = self.data.count
    fields = self.data.first(number_params).map{|value| value[0] unless value[1].empty?}
    self.errors.add(:data, "Faltan datos por ingresar") if  (fields.any? &:nil?)
  end

end
