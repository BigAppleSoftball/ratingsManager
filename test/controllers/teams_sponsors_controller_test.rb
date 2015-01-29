require 'test_helper'

class TeamsSponsorsControllerTest < ActionController::TestCase
  setup do
    @teams_sponsor = teams_sponsors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teams_sponsors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create teams_sponsor" do
    assert_difference('TeamsSponsor.count') do
      post :create, teams_sponsor: { is_active: @teams_sponsor.is_active, link_id: @teams_sponsor.link_id, sponsor_id: @teams_sponsor.sponsor_id, team_id: @teams_sponsor.team_id }
    end

    assert_redirected_to teams_sponsor_path(assigns(:teams_sponsor))
  end

  test "should show teams_sponsor" do
    get :show, id: @teams_sponsor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @teams_sponsor
    assert_response :success
  end

  test "should update teams_sponsor" do
    patch :update, id: @teams_sponsor, teams_sponsor: { is_active: @teams_sponsor.is_active, link_id: @teams_sponsor.link_id, sponsor_id: @teams_sponsor.sponsor_id, team_id: @teams_sponsor.team_id }
    assert_redirected_to teams_sponsor_path(assigns(:teams_sponsor))
  end

  test "should destroy teams_sponsor" do
    assert_difference('TeamsSponsor.count', -1) do
      delete :destroy, id: @teams_sponsor
    end

    assert_redirected_to teams_sponsors_path
  end
end
