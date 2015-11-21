require 'rails_helper'

describe Line do
  it { should belong_to(:user) }
  it { should have_many(:line_entries) }

  it "sets slug name on creating" do
    user = User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com',
      password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now)
    line = user.lines.new(name: 'Creating a new line')
    line.save
    expect(line.slug_name).to eq 'creating_a_new_line'
  end

  it "sets slug name on updating" do
    user = User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com',
      password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now)
    line = user.lines.new(name: 'Creating a new line')
    line.save
    line.name = 'this is the new name'
    line.save
    expect(line.slug_name).to eq 'this_is_the_new_name'
  end
end
