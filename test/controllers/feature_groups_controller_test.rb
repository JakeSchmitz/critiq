require 'test_helper'

class FeatureGroupsControllerTest < ActionController::TestCase
  setup do
    @feature_group = feature_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feature_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feature_group" do
    assert_difference('FeatureGroup.count') do
      post :create, feature_group: { name: @feature_group.name }
    end

    assert_redirected_to feature_group_path(assigns(:feature_group))
  end

  test "should show feature_group" do
    get :show, id: @feature_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feature_group
    assert_response :success
  end

  test "should update feature_group" do
    patch :update, id: @feature_group, feature_group: { name: @feature_group.name }
    assert_redirected_to feature_group_path(assigns(:feature_group))
  end

  test "should destroy feature_group" do
    assert_difference('FeatureGroup.count', -1) do
      delete :destroy, id: @feature_group
    end

    assert_redirected_to feature_groups_path
  end
end
