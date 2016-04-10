require 'test_helper'

class AsanaRatingsControllerTest < ActionController::TestCase
  setup do
    @asana_rating = asana_ratings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:asana_ratings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create asana_rating" do
    assert_difference('AsanaRating.count') do
      post :create, asana_rating: { approved_profile_id: @asana_rating.approved_profile_id, is_approved: @asana_rating.is_approved, profile_id: @asana_rating.profile_id, rating_10: @asana_rating.rating_10, rating_11: @asana_rating.rating_11, rating_12: @asana_rating.rating_12, rating_1: @asana_rating.rating_1, rating_2: @asana_rating.rating_2, rating_3: @asana_rating.rating_3, rating_4: @asana_rating.rating_4, rating_5: @asana_rating.rating_5, rating_6: @asana_rating.rating_6, rating_7: @asana_rating.rating_7, rating_8: @asana_rating.rating_8, rating_9: @asana_rating.rating_9 }
    end

    assert_redirected_to asana_rating_path(assigns(:asana_rating))
  end

  test "should show asana_rating" do
    get :show, id: @asana_rating
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @asana_rating
    assert_response :success
  end

  test "should update asana_rating" do
    patch :update, id: @asana_rating, asana_rating: { approved_profile_id: @asana_rating.approved_profile_id, is_approved: @asana_rating.is_approved, profile_id: @asana_rating.profile_id, rating_10: @asana_rating.rating_10, rating_11: @asana_rating.rating_11, rating_12: @asana_rating.rating_12, rating_1: @asana_rating.rating_1, rating_2: @asana_rating.rating_2, rating_3: @asana_rating.rating_3, rating_4: @asana_rating.rating_4, rating_5: @asana_rating.rating_5, rating_6: @asana_rating.rating_6, rating_7: @asana_rating.rating_7, rating_8: @asana_rating.rating_8, rating_9: @asana_rating.rating_9 }
    assert_redirected_to asana_rating_path(assigns(:asana_rating))
  end

  test "should destroy asana_rating" do
    assert_difference('AsanaRating.count', -1) do
      delete :destroy, id: @asana_rating
    end

    assert_redirected_to asana_ratings_path
  end
end
