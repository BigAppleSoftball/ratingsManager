json.array!(@teams_sponsors) do |teams_sponsor|
  json.extract! teams_sponsor, :id, :team_id, :sponsor_id, :is_active, :link_id
  json.url teams_sponsor_url(teams_sponsor, format: :json)
end
