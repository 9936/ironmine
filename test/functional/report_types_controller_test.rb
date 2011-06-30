require 'test_helper'

class ReportTypesControllerTest < ActionController::TestCase
  setup do
    @report_type = report_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_type" do
    assert_difference('ReportType.count') do
      post :create, :report_type => @report_type.attributes
    end

    assert_redirected_to report_type_path(assigns(:report_type))
  end

  test "should show report_type" do
    get :show, :id => @report_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @report_type.to_param
    assert_response :success
  end

  test "should update report_type" do
    put :update, :id => @report_type.to_param, :report_type => @report_type.attributes
    assert_redirected_to report_type_path(assigns(:report_type))
  end

  test "should destroy report_type" do
    assert_difference('ReportType.count', -1) do
      delete :destroy, :id => @report_type.to_param
    end

    assert_redirected_to report_types_path
  end
end
