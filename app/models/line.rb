class Line < ActiveRecord::Base
  belongs_to :user
  has_many :line_entries, dependent: :destroy

  before_save :set_slug_name

  private
  def set_slug_name
    self.slug_name = self.name.parameterize(sep="_")
  end
end
