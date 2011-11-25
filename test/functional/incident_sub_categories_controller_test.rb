require 'test_helper'

class IncidentSubCategoriesControllerTest < ActionController::TestCase
  setup do
    @incident_sub_category = incident_sub_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incident_sub_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incident_sub_category" do
    assert_difference('IncidentSubCategory.count') do
      post :create, incident_sub_category: @incident_sub_category.attributes
    end

    assert_redirected_to incident_sub_category_path(assigns(:incident_sub_category))
  end

  test "should show incident_sub_category" do
    get :show, id: @incident_sub_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @incident_sub_category.to_param
    assert_response :success
  end

  test "should update incident_sub_category" do
    put :update, id: @incident_sub_category.to_param, incident_sub_category: @incident_sub_category.attributes
    assert_redirected_to incident_sub_category_path(assigns(:incident_sub_category))
  end

  test "should destroy incident_sub_category" do
    assert_difference('IncidentSubCategory.count', -1) do
      delete :destroy, id: @incident_sub_category.to_param
    end

    assert_redirected_to incident_sub_categories_path
  end
end
