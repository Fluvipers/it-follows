require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  it { should belong_to(:line) }
end
