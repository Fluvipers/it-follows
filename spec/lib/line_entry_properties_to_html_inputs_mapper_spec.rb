require 'rails_helper'
require 'line_entry_properties_to_html_inputs_mapper.rb'

RSpec.describe LineEntryPropertiesToHtmlInputsMapper do
  describe "#map_properties" do
    it "returns a collection of form inputs for the properties given" do
      properties = [{"name" => 'Title', "required" => "true"},
        {"name" => 'Percentage', "required" => "false"}]

      values = { "title" => "the title", "percentage" => "80" }

      subject = LineEntryPropertiesToHtmlInputsMapper.new([:line_entry, :data], properties, values)
      result = subject.map_properties

      expect(result).to eq [
        "<label for=\"line_entry_data_title\">Title</label>",
        "<input name=\"line_entry[data][title]\" id=\"line_entry_data_title\" value=\"the title\" required=\"required\"></input>",

        "<label for=\"line_entry_data_percentage\">Percentage</label>",
        "<input name=\"line_entry[data][percentage]\" id=\"line_entry_data_percentage\" value=\"80\"></input>"]
    end
  end
end
