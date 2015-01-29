require 'test_helper'

class RostersControllerTest < ActionController::TestCase
  setup do
    @roster = rosters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rosters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roster" do
    assert_difference('Roster.count') do
      post :create, roster: { date_approved: @roster.date_approved, date_created: @roster.date_created, date_updated: @roster.date_updated, is_active: @roster.is_active, is_approved: @roster.is_approved, is_confirmed: @roster.is_confirmed, is_manager: @roster.is_manager, is_player: @roster.is_player, is_rep: @roster.is_rep, profile_id: @roster.profile_id, team_id: @roster.team_id }
    end

    assert_redirected_to roster_path(assigns(:roster))
  end

  test "should show roster" do
    get :show, id: @roster
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @roster
    assert_response :success
  end

  test "should update roster" do
    patch :update, id: @roster, roster: { date_approved: @roster.date_approved, date_created: @roster.date_created, date_updated: @roster.date_updated, is_active: @roster.is_active, is_approved: @roster.is_approved, is_confirmed: @roster.is_confirmed, is_manager: @roster.is_manager, is_player: @roster.is_player, is_rep: @roster.is_rep, profile_id: @roster.profile_id, team_id: @roster.team_id }
    assert_redirected_to roster_path(assigns(:roster))
  end

  test "should destroy roster" do
    assert_difference('Roster.count', -1) do
      delete :destroy, id: @roster
    end

    assert_redirected_to rosters_path
  end
end
