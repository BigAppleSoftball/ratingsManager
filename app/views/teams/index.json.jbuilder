json.array!(@teams) do |team|
  json.extract! team, :id, :division_id, :long_name, :stat_loss, :stat_win, :stat_play, :stat_pt_allowed, :stat_pt_scored, :stat_tie, :teamsnap_id, :description, :name
  json.url team_url(team, format: :json)
end
