json.array!(@motions) do |motion|
  json.extract! motion, :id, :title, :description, :is_active, :is_anonymous
  json.url motion_url(motion, format: :json)
end
