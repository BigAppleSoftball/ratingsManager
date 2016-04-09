require 'test_helper'

class RolesPermissionsControllerTest < ActionController::TestCase
  setup do
    @roles_permission = roles_permissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roles_permissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roles_permission" do
    assert_difference('RolesPermission.count') do
      post :create, roles_permission: { permissions_id: @roles_permission.permissions_id, role_id: @roles_permission.role_id }
    end

    assert_redirected_to roles_permission_path(assigns(:roles_permission))
  end

  test "should show roles_permission" do
    get :show, id: @roles_permission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @roles_permission
    assert_response :success
  end

  test "should update roles_permission" do
    patch :update, id: @roles_permission, roles_permission: { permissions_id: @roles_permission.permissions_id, role_id: @roles_permission.role_id }
    assert_redirected_to roles_permission_path(assigns(:roles_permission))
  end

  test "should destroy roles_permission" do
    assert_difference('RolesPermission.count', -1) do
      delete :destroy, id: @roles_permission
    end

    assert_redirected_to roles_permissions_path
  end
end
