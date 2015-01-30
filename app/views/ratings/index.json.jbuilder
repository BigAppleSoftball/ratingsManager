json.array!(@ratings) do |rating|
  json.extract! rating, :id, :profile_id, :rating_notes, :approver_notes, :rating_list, :rating_total, :date_rated, :date_approved, :rated_by_profile_id, :approved_by_profile_id, :is_provisional, :is_approved, :is_active, :history, :updated, :rating_1, :rating_2, :rating_3, :rating_4, :rating_5, :rating_6, :rating_7, :rating_8, :rating_9, :rating_10, :rating_11, :rating_12, :rating_13, :rating_14, :rating_15, :rating_16, :rating_17, :rating_18, :rating_19, :rating_20, :rating_21, :rating_22, :rating_23, :rating_24, :rating_25, :rating_26, :rating_27, :ssma_timestamp, :ng, :nr
  json.url rating_url(rating, format: :json)
end
