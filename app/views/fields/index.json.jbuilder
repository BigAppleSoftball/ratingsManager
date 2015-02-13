json.array!(@fields) do |field|
  json.extract! field, :id, :status, :name, :directions, :url, :google_map_url
  json.url field_url(field, format: :json)
end
