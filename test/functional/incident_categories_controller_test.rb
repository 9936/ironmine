require 'test_helper'

class IncidentCategoriesControllerTest < ActionController::TestCase
  setup do
    @incident_category = incident_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incident_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incident_category" do
    assert_difference('IncidentCategory.count') do
      post :create, incident_category: @incident_category.attributes
    end

    assert_redirected_to incident_category_path(assigns(:incident_category))
  end

  test "should show incident_category" do
    get :show, id: @incident_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @incident_category.to_param
    assert_response :success
  end

  test "should update incident_category" do
    put :update, id: @incident_category.to_param, incident_category: @incident_category.attributes
    assert_redirected_to incident_category_path(assigns(:incident_category))
  end

  test "should destroy incident_category" do
    assert_difference('IncidentCategory.count', -1) do
      delete :destroy, id: @incident_category.to_param
    end

    assert_redirected_to incident_categories_path
  end
end
