require 'rails_helper'

RSpec.describe Property, type: :model do
  it { should belong_to(:line) }

  context "When a Property is created validates required fields" do
    let(:line) {FactoryGirl.create(:line)}

    context "When name is not present" do
      it "should not create the property" do
        property = line.properties.build(required: true, data_type: 'Algo')

        expect(property.save).to eq false
        expect(property.errors).to include(:name)
      end
    end
    context "When required fields are present and validates type of data_type" do
      context "#data_type is boolean" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Boolean")

          expect(property.save).to eq true
          expect(property.errors).to_not include(:name)
        end
      end
      context "#data_type is string" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "String")

          expect(property.save).to eq true
          expect(property.errors).to_not include(:data_type)
          expect(Property.count).to eq 2
        end
      end
      context "#data_type is date" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Date")

          expect(property.save).to eq true
          expect(property.errors).to_not include(:data_type)
          expect(Property.count).to eq 2
        end
      end
      context "#data_type is decimal" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Decimal")

          expect(property.save).to eq true
          expect(property.errors).to_not include(:data_type)
          expect(Property.count).to eq 2
        end
      end
      context "#data_type is integer" do
        it "should create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Integer")

          expect(property.save).to eq true
          expect(property.errors).to_not include(:data_type)
          expect(Property.count).to eq 2
        end
      end
      context "#data_type is array" do
        it "should not create the property" do
          property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "Array")

          expect(property.save).to eq false
          expect(property.errors).to include(:data_type)
          expect(Property.count).to eq 1
        end
      end
    end
    context "When all the required fields are present" do
      it "should create the property" do
        property = line.properties.build(required: true, name: 'Nueva Propiedad', data_type: "String")

        expect(Property.count).to eq 1
        expect(property.save).to eq true
        expect(Property.count).to eq 2
      end
    end
  end
end
