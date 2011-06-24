require 'test_helper'

class ReportTypeCategoriesControllerTest < ActionController::TestCase
  setup do
    @report_type_category = report_type_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_type_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_type_category" do
    assert_difference('ReportTypeCategory.count') do
      post :create, :report_type_category => @report_type_category.attributes
    end

    assert_redirected_to report_type_category_path(assigns(:report_type_category))
  end

  test "should show report_type_category" do
    get :show, :id => @report_type_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @report_type_category.to_param
    assert_response :success
  end

  test "should update report_type_category" do
    put :update, :id => @report_type_category.to_param, :report_type_category => @report_type_category.attributes
    assert_redirected_to report_type_category_path(assigns(:report_type_category))
  end

  test "should destroy report_type_category" do
    assert_difference('ReportTypeCategory.count', -1) do
      delete :destroy, :id => @report_type_category.to_param
    end

    assert_redirected_to report_type_categories_path
  end
end
