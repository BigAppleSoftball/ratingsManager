require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  setup do
    @rating = ratings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ratings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rating" do
    assert_difference('Rating.count') do
      post :create, rating: { approved_by_profile_id: @rating.approved_by_profile_id, approver_notes: @rating.approver_notes, date_approved: @rating.date_approved, date_rated: @rating.date_rated, history: @rating.history, is_active: @rating.is_active, is_approved: @rating.is_approved, is_provisional: @rating.is_provisional, ng: @rating.ng, nr: @rating.nr, profile_id: @rating.profile_id, rated_by_profile_id: @rating.rated_by_profile_id, rating_10: @rating.rating_10, rating_11: @rating.rating_11, rating_12: @rating.rating_12, rating_13: @rating.rating_13, rating_14: @rating.rating_14, rating_15: @rating.rating_15, rating_16: @rating.rating_16, rating_17: @rating.rating_17, rating_18: @rating.rating_18, rating_19: @rating.rating_19, rating_1: @rating.rating_1, rating_20: @rating.rating_20, rating_21: @rating.rating_21, rating_22: @rating.rating_22, rating_23: @rating.rating_23, rating_24: @rating.rating_24, rating_25: @rating.rating_25, rating_26: @rating.rating_26, rating_27: @rating.rating_27, rating_2: @rating.rating_2, rating_3: @rating.rating_3, rating_4: @rating.rating_4, rating_5: @rating.rating_5, rating_6: @rating.rating_6, rating_7: @rating.rating_7, rating_8: @rating.rating_8, rating_9: @rating.rating_9, rating_list: @rating.rating_list, rating_notes: @rating.rating_notes, rating_total: @rating.rating_total, ssma_timestamp: @rating.ssma_timestamp, updated: @rating.updated }
    end

    assert_redirected_to rating_path(assigns(:rating))
  end

  test "should show rating" do
    get :show, id: @rating
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rating
    assert_response :success
  end

  test "should update rating" do
    patch :update, id: @rating, rating: { approved_by_profile_id: @rating.approved_by_profile_id, approver_notes: @rating.approver_notes, date_approved: @rating.date_approved, date_rated: @rating.date_rated, history: @rating.history, is_active: @rating.is_active, is_approved: @rating.is_approved, is_provisional: @rating.is_provisional, ng: @rating.ng, nr: @rating.nr, profile_id: @rating.profile_id, rated_by_profile_id: @rating.rated_by_profile_id, rating_10: @rating.rating_10, rating_11: @rating.rating_11, rating_12: @rating.rating_12, rating_13: @rating.rating_13, rating_14: @rating.rating_14, rating_15: @rating.rating_15, rating_16: @rating.rating_16, rating_17: @rating.rating_17, rating_18: @rating.rating_18, rating_19: @rating.rating_19, rating_1: @rating.rating_1, rating_20: @rating.rating_20, rating_21: @rating.rating_21, rating_22: @rating.rating_22, rating_23: @rating.rating_23, rating_24: @rating.rating_24, rating_25: @rating.rating_25, rating_26: @rating.rating_26, rating_27: @rating.rating_27, rating_2: @rating.rating_2, rating_3: @rating.rating_3, rating_4: @rating.rating_4, rating_5: @rating.rating_5, rating_6: @rating.rating_6, rating_7: @rating.rating_7, rating_8: @rating.rating_8, rating_9: @rating.rating_9, rating_list: @rating.rating_list, rating_notes: @rating.rating_notes, rating_total: @rating.rating_total, ssma_timestamp: @rating.ssma_timestamp, updated: @rating.updated }
    assert_redirected_to rating_path(assigns(:rating))
  end

  test "should destroy rating" do
    assert_difference('Rating.count', -1) do
      delete :destroy, id: @rating
    end

    assert_redirected_to ratings_path
  end
end
