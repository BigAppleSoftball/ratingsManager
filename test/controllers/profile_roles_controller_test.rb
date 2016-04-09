require 'test_helper'

class ProfileRolesControllerTest < ActionController::TestCase
  setup do
    @profile_role = profile_roles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profile_roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile_role" do
    assert_difference('ProfileRole.count') do
      post :create, profile_role: { profle_id: @profile_role.profle_id, role_id: @profile_role.role_id }
    end

    assert_redirected_to profile_role_path(assigns(:profile_role))
  end

  test "should show profile_role" do
    get :show, id: @profile_role
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profile_role
    assert_response :success
  end

  test "should update profile_role" do
    patch :update, id: @profile_role, profile_role: { profle_id: @profile_role.profle_id, role_id: @profile_role.role_id }
    assert_redirected_to profile_role_path(assigns(:profile_role))
  end

  test "should destroy profile_role" do
    assert_difference('ProfileRole.count', -1) do
      delete :destroy, id: @profile_role
    end

    assert_redirected_to profile_roles_path
  end
end
