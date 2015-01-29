require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile" do
    assert_difference('Profile.count') do
      post :create, profile: { address: @profile.address, display_name: @profile.display_name, dob: @profile.dob, email: @profile.email, emergency_email: @profile.emergency_email, emergency_name: @profile.emergency_name, emergency_phone: @profile.emergency_phone, emergency_relation: @profile.emergency_relation, first_name: @profile.first_name, gender: @profile.gender, last_name: @profile.last_name, nickname: @profile.nickname, phone: @profile.phone, player_number: @profile.player_number, position: @profile.position, profile_code: @profile.profile_code, shirt_size: @profile.shirt_size, state: @profile.state, team_id: @profile.team_id, zip: @profile.zip }
    end

    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should show profile" do
    get :show, id: @profile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profile
    assert_response :success
  end

  test "should update profile" do
    patch :update, id: @profile, profile: { address: @profile.address, display_name: @profile.display_name, dob: @profile.dob, email: @profile.email, emergency_email: @profile.emergency_email, emergency_name: @profile.emergency_name, emergency_phone: @profile.emergency_phone, emergency_relation: @profile.emergency_relation, first_name: @profile.first_name, gender: @profile.gender, last_name: @profile.last_name, nickname: @profile.nickname, phone: @profile.phone, player_number: @profile.player_number, position: @profile.position, profile_code: @profile.profile_code, shirt_size: @profile.shirt_size, state: @profile.state, team_id: @profile.team_id, zip: @profile.zip }
    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should destroy profile" do
    assert_difference('Profile.count', -1) do
      delete :destroy, id: @profile
    end

    assert_redirected_to profiles_path
  end
end
