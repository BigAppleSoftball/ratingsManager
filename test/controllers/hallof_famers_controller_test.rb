require 'test_helper'

class HallofFamersControllerTest < ActionController::TestCase
  setup do
    @hallof_famer = hallof_famers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hallof_famers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hallof_famer" do
    assert_difference('HallofFamer.count') do
      post :create, hallof_famer: { date_inducted: @hallof_famer.date_inducted, is_active: @hallof_famer.is_active, is_inducted: @hallof_famer.is_inducted, profile_id: @hallof_famer.profile_id }
    end

    assert_redirected_to hallof_famer_path(assigns(:hallof_famer))
  end

  test "should show hallof_famer" do
    get :show, id: @hallof_famer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hallof_famer
    assert_response :success
  end

  test "should update hallof_famer" do
    patch :update, id: @hallof_famer, hallof_famer: { date_inducted: @hallof_famer.date_inducted, is_active: @hallof_famer.is_active, is_inducted: @hallof_famer.is_inducted, profile_id: @hallof_famer.profile_id }
    assert_redirected_to hallof_famer_path(assigns(:hallof_famer))
  end

  test "should destroy hallof_famer" do
    assert_difference('HallofFamer.count', -1) do
      delete :destroy, id: @hallof_famer
    end

    assert_redirected_to hallof_famers_path
  end
end
