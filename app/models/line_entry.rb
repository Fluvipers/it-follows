class LineEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :line

  def to_param
    ActiveSupport::Inflector.parameterize(self.title)
  end

  jsonb_accessor(:data, title: :string, advertiser: :string, client: :string)
end
