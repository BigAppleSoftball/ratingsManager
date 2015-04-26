require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    @game = games(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post :create, game: { away_score: @game.away_score, away_team_id: @game.away_team_id, day_id: @game.day_id, field: @game.field, home_score: @game.home_score, home_team_id: @game.home_team_id, integer: @game.integer, is_active: @game.is_active, is_flip: @game.is_flip, is_rainout: @game.is_rainout, start_time: @game.start_time }
    end

    assert_redirected_to game_path(assigns(:game))
  end

  test "should show game" do
    get :show, id: @game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game
    assert_response :success
  end

  test "should update game" do
    patch :update, id: @game, game: { away_score: @game.away_score, away_team_id: @game.away_team_id, day_id: @game.day_id, field: @game.field, home_score: @game.home_score, home_team_id: @game.home_team_id, integer: @game.integer, is_active: @game.is_active, is_flip: @game.is_flip, is_rainout: @game.is_rainout, start_time: @game.start_time }
    assert_redirected_to game_path(assigns(:game))
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete :destroy, id: @game
    end

    assert_redirected_to games_path
  end
end
