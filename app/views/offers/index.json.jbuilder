json.array!(@offers) do |offer|
  json.extract! offer, :id, :name, :description, :image, :link, :google_map_url, :company_name
  json.url offer_url(offer, format: :json)
end
