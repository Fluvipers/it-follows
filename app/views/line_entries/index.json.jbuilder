json.array!(@line_entries) do |line_entry|
  json.extract! line_entry, :id, :user_id, :line_id, :data
end
