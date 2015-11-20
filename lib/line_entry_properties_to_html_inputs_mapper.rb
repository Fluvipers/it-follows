
class LineEntryPropertiesToHtmlInputsMapper
  include ActionView::Helpers
  def initialize(properties)
    @properties = properties
  end

  def map_properties
    [content_tag(:label, "Title", for: "title"), content_tag(:input, "", name: "title", id: "title", required: :required)]
  end
end
