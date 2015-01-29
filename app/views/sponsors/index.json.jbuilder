json.array!(@sponsors) do |sponsor|
  json.extract! sponsor, :id, :Sponsor_id, :name, :url, :email, :phone, :details, :date_created, :date_updated, :created_user_id, :updated_user_id, :is_active
  json.url sponsor_url(sponsor, format: :json)
end
