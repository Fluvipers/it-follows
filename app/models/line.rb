class Line < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  has_many :line_entries, dependent: :destroy
  has_many :properties, dependent: :destroy

  validates :name, uniqueness: { case_sensitive: false, message: "There is already a line with that name"}
  before_save :set_slug_name
  after_save :find_or_create_property_name

  accepts_nested_attributes_for :properties

  private
  def find_or_create_property_name
    property = self.properties.find_or_create_by(name: 'name')
    property.required = true
    property.save!
  end

  def set_slug_name
    self.slug_name = self.name.parameterize(sep="_")
  end
end
