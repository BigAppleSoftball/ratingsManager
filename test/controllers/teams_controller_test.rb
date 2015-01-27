require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  setup do
    @team = teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team" do
    assert_difference('Team.count') do
      post :create, team: { division_id: @team.division_id, long_name: @team.long_name, name: @team.name, stat_loss: @team.stat_loss, stat_play: @team.stat_play, stat_pt_allowed: @team.stat_pt_allowed, stat_pt_scored: @team.stat_pt_scored, stat_tie: @team.stat_tie, stat_win: @team.stat_win, team_desc: @team.team_desc, teamsnap_id: @team.teamsnap_id }
    end

    assert_redirected_to team_path(assigns(:team))
  end

  test "should show team" do
    get :show, id: @team
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @team
    assert_response :success
  end

  test "should update team" do
    patch :update, id: @team, team: { division_id: @team.division_id, long_name: @team.long_name, name: @team.name, stat_loss: @team.stat_loss, stat_play: @team.stat_play, stat_pt_allowed: @team.stat_pt_allowed, stat_pt_scored: @team.stat_pt_scored, stat_tie: @team.stat_tie, stat_win: @team.stat_win, team_desc: @team.team_desc, teamsnap_id: @team.teamsnap_id }
    assert_redirected_to team_path(assigns(:team))
  end

  test "should destroy team" do
    assert_difference('Team.count', -1) do
      delete :destroy, id: @team
    end

    assert_redirected_to teams_path
  end
end
