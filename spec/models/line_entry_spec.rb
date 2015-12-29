require 'rails_helper'

RSpec.describe LineEntry, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:line) }

  describe "validate creation of a new line_entry" do
    let(:user) { FactoryGirl.create(:user) }

    let(:cashout) { user.lines.create!(name: 'Cashouts') }

    let(:property1) {cashout.properties.create!(name: 'Campaign', required: true)}
    let(:property2) {cashout.properties.create!(name: 'Influencer', required: false)}

    context "when the line has no required properties" do
      context "and #data is nil" do
        it "should not create line entry" do
          property1.required = false
          property1.save!

          expect(LineEntry.count).to eq 0
          entry = cashout.line_entries.create(user: user, data: nil)
          expect(entry.save).to eq false
          expect(LineEntry.count).to eq 0
        end
      end
      context "and #data is {}" do
        it "should not create line entry" do
          property1.required = false
          property1.save!

          expect(LineEntry.count).to eq 0
          entry = cashout.line_entries.create(user: user, data: {})
          expect(entry.save).to eq false
          expect(LineEntry.count).to eq 0
        end
      end
    end

    context "when the line has required properties" do
      context "and #data is nil" do
        it "should not create line entry" do
          expect(LineEntry.count).to eq 0
          entry = cashout.line_entries.create(user: user, data: nil)
          expect(entry.save).to eq false
          expect(LineEntry.count).to eq 0
        end
      end
      context "and #data is {}" do
        it "should not create line entry" do
          expect(LineEntry.count).to eq 0
          entry = cashout.line_entries.create(user: user, data: {})
          expect(entry.save).to eq false
          expect(LineEntry.count).to eq 0
        end
      end
      context "and data has values but misses some required properties" do
        it "should not create line entry" do
          property3 = cashout.properties.create!(name: 'Number_Post', required: true)

          cashout.save!
          entry = cashout.line_entries.create(user: user, data: {campaign: "Nickelodeon"})
          expect(entry.save).to eq false
          expect(LineEntry.count).to   eq 0
        end
      end
      context "and data has values for all required properties" do
        it "should create line entry" do
          expect(LineEntry.count).to eq 0
          entry = cashout.line_entries.create(user: user, data: {campaign: "Nickelodeon"})
          expect(entry.save).to eq true
          expect(LineEntry.count).to eq 1
        end
      end
    end
  end

  describe "#validation_parameters" do
    let(:user) { User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com', password: '12345678', 
               password_confirmation: '12345678', confirmed_at: Time.now) }

    let(:cashout) { user.lines.create!(name: 'Cashouts') }

    let(:property1) {cashout.properties.create!(name: 'Campaign', required: true)}
    let(:property2) {cashout.properties.create!(name: 'Influencer', required: false)}

    context "when the line has no required properties" do
      context "and #data is nil" do
        it "should not add error messages" do
          property1.required = false
          property1.save!

          entry = cashout.line_entries.new(user: user, data: nil)
          entry.valid?
          entry.errors.should_not have_key :campaign
          entry.errors.should_not have_key :influencer
        end
      end
      context "and #data is {}" do
        it "should not add error messages" do
          property1.required = false
          property1.save!

          entry = cashout.line_entries.new(user: user, data: nil)
          entry.valid?
          entry.errors.should_not have_key :campaign
          entry.errors.should_not have_key :influencer
        end
      end
    end

    context "when the line has required properties" do
      context "and #data is nil" do
        it "adds an error message for the missing required fields" do
          property1 = cashout.properties.create!(name: 'Campaign', required: true)
          property2 = cashout.properties.create!(name: 'Influencer', required: false)
          entry = cashout.line_entries.new(user: user, data: nil)
          entry.valid?
          entry.errors.should have_key :campaign
          entry.errors.should_not have_key :influencer
        end
      end
      context "and #data is {}" do
        it "adds an error message for the missing required fields" do
          property1 = cashout.properties.create!(name: 'Campaign', required: true)
          property2 = cashout.properties.create!(name: 'Influencer', required: false)
          entry = cashout.line_entries.new(user: user, data: {})
          entry.valid?
          entry.errors.should have_key :campaign
          entry.errors.should_not have_key :influencer
        end
      end
      context "and data has values but misses some required properties" do
        it "adds an error message for the missing required fields" do
          property3 = cashout.properties.create!(name: 'Number_Post', required: true)

          entry = cashout.line_entries.new(user: user, data: {campaign: "Nickelodeon"})
          entry.valid?
          entry.errors.should_not have_key :campaign
          entry.errors.should have_key :number_post
          entry.errors.should_not have_key :influencer
        end
      end
      context "and data has values for all required properties" do
        it "should not add error messages" do
          entry = cashout.line_entries.new(user: user, data: {campaign: "Nickelodeon"})
          entry.valid?
          entry.errors.should_not have_key :campaign
          entry.errors.should_not have_key :influencer
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

  describe "when the line entry is edited" do
    let(:user) { FactoryGirl.create(:user) }

    let(:cashout) { user.lines.create!(name: 'Cashouts') }

    let(:entry) { cashout.line_entries.create!(user: user, data: {campaign: "Nickelodeon"}) }

    context "and there is followup" do
      context "and there is a task" do
        context "and the task is valid" do
          it "should create the task and the followup" do
            followup = entry.followups.new
            followup.user_id = user.id
            followup.description = "Un nuevo followup"
            followup.percentage = 8

            tasks = followup.tasks.build(user: user, description: 'Nueva Tarea')

            expect(Followup.count).to eq 0
            expect(Task.count).to eq 0
            expect(followup.save).to eq true
            expect(Followup.count).to eq 1
            expect(Task.count).to eq 1
          end
        end
        context "and the task is not valid" do
          it "should not create the task and the followup" do
            followup = entry.followups.new
            followup.user_id = user.id
            followup.description = "Un nuevo followup"
            followup.percentage = 8

            tasks = followup.tasks.build(user: user)

            expect(Followup.count).to eq 0
            expect(Task.count).to eq 0
            expect(followup.save).to eq false
            expect(Followup.count).to eq 0
            expect(Task.count).to eq 0
          end
        end
      end
      context "and there is no task" do
        it "should not create a task and should create the followup" do
          followup = entry.followups.new
          followup.user_id = user.id
          followup.description = "Un nuevo followup"
          followup.percentage = 8

          expect(Followup.count).to eq 0
          expect(Task.count).to eq 0
          expect(followup.save).to eq true
          expect(Followup.count).to eq 1
          expect(Task.count).to eq 0
        end
      end
    end
  end
end
