json.array!(@hallof_famers) do |hallof_famer|
  json.extract! hallof_famer, :id, :profile_id, :date_inducted, :is_active, :is_inducted
  json.url hallof_famer_url(hallof_famer, format: :json)
end
