json.array!(@rosters) do |roster|
  json.extract! roster, :id, :team_id, :profile_id, :date_created, :date_approved, :date_updated, :is_approved, :is_player, :is_rep, :is_manager, :is_active, :is_confirmed
  json.url roster_url(roster, format: :json)
end
