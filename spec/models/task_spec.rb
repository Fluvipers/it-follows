require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:followup) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:description) }
end
