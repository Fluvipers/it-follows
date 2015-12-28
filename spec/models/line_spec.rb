require 'rails_helper'

describe Line do
  it { should belong_to(:user) }
  it { should have_many(:line_entries) }

  let(:user) { FactoryGirl.create(:user) }

  it "sets slug name on creating" do
    line = user.lines.new(name: 'Creating a new line', properties:[{"name":"Advdertiser", required: true }])
    line.save
    expect(line.slug_name).to eq 'creating_a_new_line'
  end

  it "sets slug name on updating" do
    line = user.lines.new(name: 'Creating a new line', properties:[{"name":"Advdertiser", required: true }])
    line.save
    line.name = 'this is the new name'
    line.save
    expect(line.slug_name).to eq 'this_is_the_new_name'
  end

  context "When a new line is created validates required fields" do
    context "when properties field is not valid" do
      context "when is not present" do
        it "should not create a line" do
          line_new = Line.new
          line_new.name = 'Nueva Linea'
          line_new.user_id = user.id

          expect(Line.count).to eq 0
          expect(line_new.save).to eq false
          expect(Line.count).to eq 0
        end
      end
      context "when is an empty array" do
        it "should not create a line" do
          line_new = Line.new
          line_new.name = 'Nueva Linea'
          line_new.properties = []
          line_new.user_id = user.id

          expect(Line.count).to eq 0
          expect(line_new.save).to eq false
          expect(Line.count).to eq 0
        end
      end
    end
    it "should not create a line if name field is not present" do
      line_new = Line.new
      line_new.user_id = user.id
      line_new.properties = [{name: 'Nuevo', required: true}]

      expect(Line.count).to eq 0
      expect(line_new.save).to eq false
      expect(Line.count).to eq 0
    end
    it "should not create a line if user field is not present" do
      line_new = Line.new
      line_new.name = 'Nueva Linea'
      line_new.properties = [{name: 'Nuevo', required: true}]

      expect(Line.count).to eq 0
      expect(line_new.save).to eq false
      expect(Line.count).to eq 0
    end
  end

  context "Create a new line with a name that already exists" do
    it "and this has some capitalize letters" do
      line_number_one = FactoryGirl.create(:line)
      line_new = Line.new

      expect(Line.count).to eq 1

      line_new.user_id = line_number_one.user.id
      line_new.name = "a nEw Line"
      line_new.properties = [{"name"=>"Title", "required"=>true}, {"name"=>"Advertiser", "required"=>true}]

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
      line_new.properties = [{"name"=>"Title", "required"=>true}, {"name"=>"Advertiser", "required"=>true}]

      expect(line_new.save).to eq false
      line_new.should_not be_valid
      expect(Line.count).to eq 1
    end
  end
end
