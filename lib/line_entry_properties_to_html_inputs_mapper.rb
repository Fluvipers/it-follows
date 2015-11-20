class LineEntryPropertiesToHtmlInputsMapper
  include ActionView::Helpers
  def initialize(context, properties)
    @context = context
    @properties = properties
  end

  def map_properties
    name_context = create_name_context
    id_context = create_id_context

    @properties.map do |property|
      [content_tag(:label, "#{property[:name].titleize}", for: "#{id_context}_#{property[:name].downcase}"),
      content_tag(:input, "", name: "#{name_context}[#{property[:name].downcase}]", id: "#{id_context}_#{property[:name].downcase}", 
      required: (:required if property[:required]))]

    end.flatten
  end

  private
  def create_name_context
    context = @context.dup
    base = context.shift.to_s
    "#{base}[#{context.join("][")}]"
  end

  def create_id_context
    context = @context.dup
    "#{context.join("_")}"
  end
end


