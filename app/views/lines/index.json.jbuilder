json.array!(@lines) do |line|
  json.extract! line, :id, :user_id, :name, :properties
  json.url line_url(line, format: :json)
end
