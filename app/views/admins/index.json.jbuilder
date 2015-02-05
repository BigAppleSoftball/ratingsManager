json.array!(@admins) do |admin|
  json.extract! admin, :id, :email
  json.url admin_url(admin, format: :json)
end
