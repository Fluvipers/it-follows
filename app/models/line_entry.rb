class LineEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :line

  has_many :followups, dependent: :destroy
  has_many :tasks, through: :followups

  accepts_nested_attributes_for :followups
  validates_presence_of :data
  validate :validation_parameters

  def ransackable_attributes(auth_object = nil)
    super & %w(name price)
  end

  def current_percentage
    followups.last.try(:percentage).to_i
  end

  def needs_followup?
    current_percentage < 100
  end

  def validation_parameters
    required_properties = self.line.properties.select(&:required).map{ |property| property.name.downcase }
    has_not_data? ? add_errors(required_properties) : add_errors(data_required(required_properties))
  end

  def has_not_data?
    self.data.nil? || self.data.empty?
  end

  def data_required(required_properties)
    name_rule = required_properties.map {|f| f if (self.data[f].nil? || self.data[f].empty?)}.compact
  end

  def add_errors(missed_properties)
    missed_properties.each { |p| errors.add(p.to_sym, "El campo #{p} no puede estar vacio") if true}
  end
end
