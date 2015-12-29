require 'rails_helper'

describe Line do
  it { should belong_to(:user) }
  it { should have_many(:line_entries) }
  it { should have_many(:properties) }

  let(:user) { FactoryGirl.create(:user) }

  it "sets slug name on creating" do
    line = user.lines.new(name: 'Creating a new line')
    line.save
    expect(line.slug_name).to eq 'creating_a_new_line'
  end

  it "sets slug name on updating" do
    line = user.lines.new(name: 'Creating a new line')
    line.save
    line.name = 'this is the new name'
    line.save
    expect(line.slug_name).to eq 'this_is_the_new_name'
  end

  context "Create a new line with a name that already exists" do
    it "and this has some capitalize letters" do
      line_number_one = FactoryGirl.create(:line)
      line_new = Line.new

      expect(Line.count).to eq 1

      line_new.user_id = line_number_one.user.id
      line_new.name = "a nEw Line"

      expect(line_new.save).to eq false
      line_new.should_not be_valid
      expect(Line.count).to eq 1
    end

    it "and this has the same name" do
      line_number_one = FactoryGirl.create(:line)
      line_new = Line.new

      expect(Line.count).to eq 1

      line_new.user_id = line_number_one.user.id
      line_new.name = "a new line"

      expect(line_new.save).to eq false
      line_new.should_not be_valid
      expect(Line.count).to eq 1
    end
  end
end
