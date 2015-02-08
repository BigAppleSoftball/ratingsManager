json.array!(@board_members) do |board_member|
  json.extract! board_member, :id, :email, :position, :display_order, :first_name, :last_nale, :alt_email, :image_url
  json.url board_member_url(board_member, format: :json)
end
