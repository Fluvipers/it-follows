require 'rails_helper'

RSpec.describe Property, type: :model do
  it { should belong_to(:line) }

  context "When a Property is created validates required fields" do
    let(:line) {FactoryGirl.create(:line)}

    context "When name is not present" do
      it "should not create the property" do
        property = line.properties.build(required: true, data_type: 'Algo')

        expect(Property.count).to eq 0
        expect(property.save).to eq false
        expect(Property.count).to eq 0
      end
    end
    context "When required fields are present and validates type of data_type" do
      context "#data_type is boolean" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Boolean")

          expect(Property.count).to eq 0
          expect(property.save).to eq true
          expect(Property.count).to eq 1
        end
      end
      context "#data_type is string" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "String")

          expect(Property.count).to eq 0
          expect(property.save).to eq true
          expect(Property.count).to eq 1
        end
      end
      context "#data_type is date" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Date")

          expect(Property.count).to eq 0
          expect(property.save).to eq true
          expect(Property.count).to eq 1
        end
      end
      context "#data_type is decimal" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Decimal")

          expect(Property.count).to eq 0
          expect(property.save).to eq true
          expect(Property.count).to eq 1
        end
      end
      context "#data_type is integer" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Integer")

          expect(Property.count).to eq 0
          expect(property.save).to eq true
          expect(Property.count).to eq 1
        end
      end
      context "#data_type is array" do
        it "should not create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Array")

          expect(Property.count).to eq 0
          expect(property.save).to eq false
          expect(Property.count).to eq 0
        end
      end
    end
    context "When all the required fields are present" do
      it "should create the property" do
        property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "String")

        expect(Property.count).to eq 0
        expect(property.save).to eq true
        expect(Property.count).to eq 1
      end
    end
  end
end
