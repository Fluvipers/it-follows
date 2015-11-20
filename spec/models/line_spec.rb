require 'rails_helper'

describe Line do
  it { should belong_to(:user) }
  it { should have_many(:line_entries) }

  describe "adding custom properties to lines for capturing on creation" do
    it "creates a string attribute and validates presence" do
      user = User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com',
        password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now)
      line = user.lines.create!(name: 'Tickets', properties: [ {name: 'description', type: :string, required: true} ])
      line.should respond_to(:description)
      line.should validate_presence_of(:description)
    end
  end
end
