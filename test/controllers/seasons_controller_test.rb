require 'test_helper'

class SeasonsControllerTest < ActionController::TestCase
  setup do
    @season = seasons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seasons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create season" do
    assert_difference('Season.count') do
      post :create, season: { : @season., date_end: @season.date_end, date_start: @season.date_start, league_id: @season.league_id, pool_id: @season.pool_id, season_desc: @season.season_desc, season_id: @season.season_id }
    end

    assert_redirected_to season_path(assigns(:season))
  end

  test "should show season" do
    get :show, id: @season
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @season
    assert_response :success
  end

  test "should update season" do
    patch :update, id: @season, season: { : @season., date_end: @season.date_end, date_start: @season.date_start, league_id: @season.league_id, pool_id: @season.pool_id, season_desc: @season.season_desc, season_id: @season.season_id }
    assert_redirected_to season_path(assigns(:season))
  end

  test "should destroy season" do
    assert_difference('Season.count', -1) do
      delete :destroy, id: @season
    end

    assert_redirected_to seasons_path
  end
end