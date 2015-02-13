json.array!(@committees) do |committee|
  json.extract! committee, :id, :email, :profile_id, :name
  json.url committee_url(committee, format: :json)
end
