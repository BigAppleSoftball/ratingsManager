require 'test_helper'

class SponsorsControllerTest < ActionController::TestCase
  setup do
    @sponsor = sponsors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sponsors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sponsor" do
    assert_difference('Sponsor.count') do
      post :create, sponsor: { Sponsor_id: @sponsor.Sponsor_id, created_user_id: @sponsor.created_user_id, date_created: @sponsor.date_created, date_updated: @sponsor.date_updated, details: @sponsor.details, email: @sponsor.email, is_active: @sponsor.is_active, name: @sponsor.name, phone: @sponsor.phone, updated_user_id: @sponsor.updated_user_id, url: @sponsor.url }
    end

    assert_redirected_to sponsor_path(assigns(:sponsor))
  end

  test "should show sponsor" do
    get :show, id: @sponsor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sponsor
    assert_response :success
  end

  test "should update sponsor" do
    patch :update, id: @sponsor, sponsor: { Sponsor_id: @sponsor.Sponsor_id, created_user_id: @sponsor.created_user_id, date_created: @sponsor.date_created, date_updated: @sponsor.date_updated, details: @sponsor.details, email: @sponsor.email, is_active: @sponsor.is_active, name: @sponsor.name, phone: @sponsor.phone, updated_user_id: @sponsor.updated_user_id, url: @sponsor.url }
    assert_redirected_to sponsor_path(assigns(:sponsor))
  end

  test "should destroy sponsor" do
    assert_difference('Sponsor.count', -1) do
      delete :destroy, id: @sponsor
    end

    assert_redirected_to sponsors_path
  end
end
