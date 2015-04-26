json.array!(@games) do |game|
  json.extract! game, :id, :day_id, :start_time, :home_team_id, :integer, :away_team_id, :is_flip, :field, :home_score, :away_score, :is_rainout, :is_active
  json.url game_url(game, format: :json)
end
