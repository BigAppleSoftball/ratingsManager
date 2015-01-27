require 'test_helper'

class DivisionsControllerTest < ActionController::TestCase
  setup do
    @division = divisions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:divisions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create division" do
    assert_difference('Division.count') do
      post :create, division: { div_description: @division.div_description, div_id: @division.div_id, div_order: @division.div_order, is_active: @division.is_active, pool_id: @division.pool_id, season_id: @division.season_id, standings: @division.standings, team_cap: @division.team_cap, waitlist_cap: @division.waitlist_cap }
    end

    assert_redirected_to division_path(assigns(:division))
  end

  test "should show division" do
    get :show, id: @division
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @division
    assert_response :success
  end

  test "should update division" do
    patch :update, id: @division, division: { div_description: @division.div_description, div_id: @division.div_id, div_order: @division.div_order, is_active: @division.is_active, pool_id: @division.pool_id, season_id: @division.season_id, standings: @division.standings, team_cap: @division.team_cap, waitlist_cap: @division.waitlist_cap }
    assert_redirected_to division_path(assigns(:division))
  end

  test "should destroy division" do
    assert_difference('Division.count', -1) do
      delete :destroy, id: @division
    end

    assert_redirected_to divisions_path
  end
end
