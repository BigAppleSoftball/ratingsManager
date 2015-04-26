require 'test_helper'

class GameAttendancesControllerTest < ActionController::TestCase
  setup do
    @game_attendance = game_attendances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_attendances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_attendance" do
    assert_difference('GameAttendance.count') do
      post :create, game_attendance: { game_id: @game_attendance.game_id, is_attending: @game_attendance.is_attending, profile_id: @game_attendance.profile_id }
    end

    assert_redirected_to game_attendance_path(assigns(:game_attendance))
  end

  test "should show game_attendance" do
    get :show, id: @game_attendance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_attendance
    assert_response :success
  end

  test "should update game_attendance" do
    patch :update, id: @game_attendance, game_attendance: { game_id: @game_attendance.game_id, is_attending: @game_attendance.is_attending, profile_id: @game_attendance.profile_id }
    assert_redirected_to game_attendance_path(assigns(:game_attendance))
  end

  test "should destroy game_attendance" do
    assert_difference('GameAttendance.count', -1) do
      delete :destroy, id: @game_attendance
    end

    assert_redirected_to game_attendances_path
  end
end
