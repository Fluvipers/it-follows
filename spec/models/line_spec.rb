require 'rails_helper'

describe Line do
  it { should belong_to(:user) }
  it { should have_many(:line_entries) }
end
