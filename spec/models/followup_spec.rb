require 'rails_helper'

RSpec.describe Followup, type: :model do
  it { should belong_to(:line_entry) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:percentage) }
  it { should validate_presence_of(:description) }
  it { should have_many(:tasks) }
  it { should have_many(:attachments) }
end
