json.array!(@roles) do |role|
  json.extract! role, :id, :name, :season_id, :division_id, :team_id
  json.url role_url(role, format: :json)
end
