require 'rails_helper'

RSpec.describe Property, type: :model do
  it { should belong_to(:line) }

  context "When a Property is created validates required fields" do
    let(:line) {FactoryGirl.create(:line)}
    context "When line_id is not present" do
      it "should not create the property" do
        property = Property.new
        property.name = 'Nueva Propiedad'
        property.required = true
        property.data_type = 'Algo'

        expect(Property.count).to eq 0
        expect(property.save).to eq false
        expect(Property.count).to eq 0
      end
    end
    context "When name is not present" do
      it "should not create the property" do
        property = line.properties.build(required: true, data_type: 'Algo')

        expect(Property.count).to eq 0
        expect(property.save).to eq false
        expect(Property.count).to eq 0
      end
    end
    context "When all the required fields are present" do
      it "should create the property" do
        property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: 'Algo')

        expect(Property.count).to eq 0
        expect(property.save).to eq true
        expect(Property.count).to eq 1
      end
    end
  end
end
