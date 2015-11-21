class LineEntryPropertiesToHtmlInputsMapper
  include ActionView::Helpers
  def initialize(context, properties, values={})
    @context = context
    @properties = properties
    @values = values
  end

  def map_properties
    name_context = build_name_context
    id_context = build_id_context

    @properties.map do |property|
      label_title = property_name(property)
      input_id = build_input_id(id_context, property)
      input_name = build_input_name(name_context, property)
      value = @values[property_name(property)]

      label = build_label(label_title, input_id)
      input = build_input(input_name, input_id, property, value)

      content_tag(:div, [label, input].join.html_safe, class: 'form-group')

    end.flatten
  end

  private

  def property_name(property)
    property["name"].downcase
  end

  def build_input_name(name, property)
    "#{name}[#{property_name(property)}]"
  end

  def build_input_id(context, property)
    "#{context}_#{property_name(property)}"
  end

  def build_label(title, input_id)
    content_tag(:label, title.titleize, for: input_id)
  end

  def build_input(name, input_id, property, value)
    content_tag(:input, nil, name: name, id: input_id, value: value,
      class: "form-control", required: make_it_required(property))
  end

  def make_it_required(property)
    :required if property["required"] == "true"
  end

  def build_name_context
    context = @context.dup
    base = context.shift.to_s
    "#{base}[#{context.join("][")}]"
  end

  def build_id_context
    context = @context.dup
    "#{context.join("_")}"
  end
end


