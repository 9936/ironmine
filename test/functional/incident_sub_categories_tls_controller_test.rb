require 'test_helper'

class IncidentSubCategoriesTlsControllerTest < ActionController::TestCase
  setup do
    @incident_sub_categories_tl = incident_sub_categories_tls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incident_sub_categories_tls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incident_sub_categories_tl" do
    assert_difference('IncidentSubCategoriesTl.count') do
      post :create, incident_sub_categories_tl: @incident_sub_categories_tl.attributes
    end

    assert_redirected_to incident_sub_categories_tl_path(assigns(:incident_sub_categories_tl))
  end

  test "should show incident_sub_categories_tl" do
    get :show, id: @incident_sub_categories_tl.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @incident_sub_categories_tl.to_param
    assert_response :success
  end

  test "should update incident_sub_categories_tl" do
    put :update, id: @incident_sub_categories_tl.to_param, incident_sub_categories_tl: @incident_sub_categories_tl.attributes
    assert_redirected_to incident_sub_categories_tl_path(assigns(:incident_sub_categories_tl))
  end

  test "should destroy incident_sub_categories_tl" do
    assert_difference('IncidentSubCategoriesTl.count', -1) do
      delete :destroy, id: @incident_sub_categories_tl.to_param
    end

    assert_redirected_to incident_sub_categories_tls_path
  end
end
