json.array!(@parks) do |park|
  json.extract! park, :id, :status, :name, :directions, :url, :google_map_url
  json.url park_url(park, format: :json)
end
