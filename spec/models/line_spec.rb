require 'rails_helper'

describe Line do
  it { should belong_to(:user) }
end
