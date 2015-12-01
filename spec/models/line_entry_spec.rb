require 'rails_helper'

RSpec.describe LineEntry, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:line) }

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
