require 'rails_helper'

RSpec.describe LineEntry, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:line) }
  it { should validate_presence_of(:data) }
end
