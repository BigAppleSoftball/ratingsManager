json.array!(@game_attendances) do |game_attendance|
  json.extract! game_attendance, :id, :profile_id, :game_id, :is_attending
  json.url game_attendance_url(game_attendance, format: :json)
end
