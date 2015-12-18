class LineEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :line

  has_many :followups, dependent: :destroy
  has_many :tasks, through: :followups

  accepts_nested_attributes_for :followups
  validates_presence_of :data
  validate :validation_parameters

  def current_percentage
    followups.last.try(:percentage).to_i
  end

  def needs_followup?
    current_percentage < 100
  end

  def validation_parameters
    required_properties = self.line.properties.map {|property| property["name"] if property["required"]}.compact
                          .map{ |property| property.downcase }
    has_not_data? ? errors_for_no_data(required_properties) : adds_errors_for_data_missed(required_properties)
  end

  def has_not_data?
    self.data.nil? || self.data.empty?
  end

  def adds_errors_for_data_missed(required_properties)

    name_rule = required_properties.map {|f| f if (self.data[f].nil? || self.data[f].empty?)}.compact
    name_rule.each { |p| errors.add(p.to_sym, "El campo #{p} no puede estar vacio") if true}
  end

  def errors_for_no_data(required_properties)
    required_properties.each { |p| errors.add(p.to_sym, "El campo #{p} no puede estar vacio") if true}
  end
end
