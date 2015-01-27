json.array!(@seasons) do |season|
  json.extract! season, :id, :season_id, :league_id, :pool_id, :season_desc, :date_start, :, :date_end
  json.url season_url(season, format: :json)
end
