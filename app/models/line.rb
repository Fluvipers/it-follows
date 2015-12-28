class Line < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  has_many :line_entries, dependent: :destroy

  validates :name, uniqueness: { case_sensitive: false, message: "There is already a line with that name"}
  before_save :set_slug_name

  private
  def set_slug_name
    self.slug_name = self.name.parameterize(sep="_")
  end
end
