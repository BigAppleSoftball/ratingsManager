json.array!(@seasons) do |season|
  json.extract! season, :id, :season_id, :league_id, :pool_id, :description, :date_start, :, :date_end
  json.url season_url(season, format: :json)
end
