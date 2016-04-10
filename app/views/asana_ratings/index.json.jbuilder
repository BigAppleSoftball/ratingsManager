json.array!(@asana_ratings) do |asana_rating|
  json.extract! asana_rating, :id, :profile_id, :is_approved, :approved_profile_id, :rating_1, :rating_2, :rating_3, :rating_4, :rating_5, :rating_6, :rating_7, :rating_8, :rating_9, :rating_10, :rating_11, :rating_12
  json.url asana_rating_url(asana_rating, format: :json)
end
