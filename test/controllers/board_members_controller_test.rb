require 'test_helper'

class BoardMembersControllerTest < ActionController::TestCase
  setup do
    @board_member = board_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:board_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create board_member" do
    assert_difference('BoardMember.count') do
      post :create, board_member: { alt_email: @board_member.alt_email, display_order: @board_member.display_order, email: @board_member.email, first_name: @board_member.first_name, image_url: @board_member.image_url, last_nale: @board_member.last_nale, position: @board_member.position }
    end

    assert_redirected_to board_member_path(assigns(:board_member))
  end

  test "should show board_member" do
    get :show, id: @board_member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @board_member
    assert_response :success
  end

  test "should update board_member" do
    patch :update, id: @board_member, board_member: { alt_email: @board_member.alt_email, display_order: @board_member.display_order, email: @board_member.email, first_name: @board_member.first_name, image_url: @board_member.image_url, last_nale: @board_member.last_nale, position: @board_member.position }
    assert_redirected_to board_member_path(assigns(:board_member))
  end

  test "should destroy board_member" do
    assert_difference('BoardMember.count', -1) do
      delete :destroy, id: @board_member
    end

    assert_redirected_to board_members_path
  end
end
