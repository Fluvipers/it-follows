class LineEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :line

  has_many :followups

  accepts_nested_attributes_for :followups

  jsonb_accessor(:data, title: :string, advertiser: :string, client: :string)
end
