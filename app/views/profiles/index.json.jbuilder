json.array!(@profiles) do |profile|
  json.extract! profile, :id, :profile_code, :first_name, :last_name, :email, :nickname, :display_name, :player_number, :gender, :shirt_size, :address, :state, :zip, :phone, :emergency_name, :emergency_relation, :emergency_phone, :emergency_email, :position, :dob, :team_id
  json.url profile_url(profile, format: :json)
end
