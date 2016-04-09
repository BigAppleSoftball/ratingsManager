json.array!(@profile_roles) do |profile_role|
  json.extract! profile_role, :id, :profle_id, :role_id
  json.url profile_role_url(profile_role, format: :json)
end
