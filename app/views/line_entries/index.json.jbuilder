json.array!(@line_entries) do |line_entry|
  json.extract! line_entry, :id, :line_id, :user_id, :data
  json.url line_entry_url(line_entry, format: :json)
end
