require 'rails_helper'
require 'line_entry_properties_to_html_inputs_mapper.rb'

RSpec.describe LineEntryPropertiesToHtmlInputsMapper do
  describe "#map_properties" do
    it "returns a collection of form inputs for the properties given" do
      properties = [{name: 'Title', type: 'string', required: true}, {name: 'Percentage', type: 'number', required: false}]
      subject = LineEntryPropertiesToHtmlInputsMapper.new(properties)
      result = subject.map_properties
      expect(result).to eq ["<label for=\"title\">Title</label>", "<input name=\"title\" id=\"title\" required=\"required\"></input>", "<label for=\"percentage\">Percentage</label>", "<input name=\"percentage\" id=\"percentage\" required=\"required\"></input>"]
    end
  end
end
