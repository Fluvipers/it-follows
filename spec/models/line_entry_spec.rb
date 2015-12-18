require 'rails_helper'

RSpec.describe LineEntry, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:line) }

  describe "#validation_parameters" do
    let(:user) { User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com', password: '12345678', 
               password_confirmation: '12345678', confirmed_at: Time.now) }

    let(:cashout) { user.lines.create!(name: 'Cashouts', properties: [{name: 'Campaign', required: true},
               {name: 'Influencer', required: false}]) }

    context "when the line has no required properties" do
      context "and #data is nil" do
        it "should not add error messages" do
          cashout.properties = [{name: 'Campaign', required: false}, {name: 'Influencer', required: false}]
          cashout.save!
          entry = cashout.line_entries.new(user: user, data: nil)
          entry.valid?
          entry.errors.should_not have_key :Campaign
          entry.errors.should_not have_key :Influencer
        end
      end
      context "and #data is {}" do
        it "should not add error messages" do
          cashout.properties = [{name: 'Campaign', required: false}, {name: 'Influencer', required: false}]
          cashout.save!
          entry = cashout.line_entries.new(user: user, data: nil)
          entry.valid?
          entry.errors.should_not have_key :Campaign
          entry.errors.should_not have_key :Influencer
        end
      end
    end

    context "when the line has required properties" do
      context "and #data is nil" do
        it "adds an error message for the missing required fields" do
          entry = cashout.line_entries.new(user: user, data: nil)
          entry.valid?
          entry.errors.should have_key :Campaign
          entry.errors.should_not have_key :Influencer
        end
      end
      context "and #data is {}" do
        it "adds an error message for the missing required fields" do
          entry = cashout.line_entries.new(user: user, data: {})
          entry.valid?
          entry.errors.should have_key :Campaign
          entry.errors.should_not have_key :Influencer
        end
      end
      context "and data has values but misses some required properties" do
        it "adds an error message for the missing required fields" do
          cashout.properties = [{name: 'number_post', required: true}, {name: 'Campaign', required: true}, 
                                {name: 'Influencer', required: false}]
          cashout.save!
          entry = cashout.line_entries.new(user: user, data: {campaign: "Nickelodeon"})
          entry.valid?
          entry.errors.should_not have_key :Campaign
          entry.errors.should have_key :Number_post
          entry.errors.should_not have_key :Influencer
        end
      end
      context "and data has values for all required properties" do
        it "should not add error messages" do
          entry = cashout.line_entries.new(user: user, data: {campaign: "Nickelodeon"})
          entry.valid?
          entry.errors.should_not have_key :Campaign
          entry.errors.should_not have_key :Influencer
        end
      end
    end
  end

  describe "#needs_followup?" do
    it "returns true when #current_percentage is lower than 100" do
      subject.followups << Followup.new(percentage: 5)
      expect(subject.needs_followup?).to eq true
    end

    it "returns false when #current_percentage is equal to 100" do
      subject.followups << Followup.new(percentage: 100)
      expect(subject.needs_followup?).to_not eq true
    end
  end

  describe "#current_percentage" do
    context "when the line entry has followups" do
      it "should return the percentage of the last followup" do
        subject.followups << Followup.new(percentage: 10)
        subject.followups << Followup.new(percentage: 5)
        expect(subject.current_percentage).to eq 5
      end
    end

    context "whene the line entry has no followups" do
      it "should return 0" do
        subject.followups = []
        expect(subject.current_percentage).to eq 0
      end
    end
  end
end
