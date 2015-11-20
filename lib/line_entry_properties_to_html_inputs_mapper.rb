
class LineEntryPropertiesToHtmlInputsMapper
  include ActionView::Helpers
  def initialize(properties)
    @properties = properties
  end

  def map_properties
    @properties.map do |property|
      [content_tag(:label, property[:name].titleize, for: property[:name].downcase),
      content_tag(:input, "", name: property[:name].downcase, id: property[:name].downcase, required: :required)]
    end.flatten
  end
end
