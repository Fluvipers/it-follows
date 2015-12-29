require 'rails_helper'

describe User do
  it { should have_many(:lines) }
  it { should have_many(:line_entries) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should have_many(:tasks) }

  describe "When a user is created should create user's screen_name" do
    context "when the username of his mail isn't in a user" do
      it "should create screen_name like email's username" do
        user = User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com', password: '12345678',
                  password_confirmation: '12345678', confirmed_at: Time.now) 

        expect(user.screen_name).to eq "wendy"
        user.save!
        expect(user.screen_name).to eq "wendy"
      end
    end

    context "when the username of his mail is in a user" do
      it "should create screen_name like email's username_domain" do
        User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com', password: '12345678',
                  password_confirmation: '12345678', confirmed_at: Time.now) 
        user = User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@fluvip.com', password: '12345678',
                  password_confirmation: '12345678', confirmed_at: Time.now) 
        expect(user.screen_name).to eq "wendy_fluvip"

        user.save!
        expect(user.screen_name).to eq "wendy_fluvip"
      end
    end
  end
end
