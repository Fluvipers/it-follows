require 'rails_helper'

describe User do
  it { should have_many(:lines) }
  it { should have_many(:line_entries) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
end
