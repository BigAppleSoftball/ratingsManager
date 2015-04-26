json.array!(@divisions) do |division|
  json.extract! division, :id, :div_id, :season_id, :pool_id, :description, :display_order, :standings, :team_cap, :waitlist_cap, :is_active
  json.url division_url(division, format: :json)
end
