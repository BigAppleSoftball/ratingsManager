json.array!(@roles_permissions) do |roles_permission|
  json.extract! roles_permission, :id, :role_id, :permissions_id
  json.url roles_permission_url(roles_permission, format: :json)
end
