require 'test_helper'

class ReportTriggersControllerTest < ActionController::TestCase
  setup do
    @report_trigger = report_triggers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_triggers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_trigger" do
    assert_difference('ReportTrigger.count') do
      post :create, :report_trigger => @report_trigger.attributes
    end

    assert_redirected_to report_trigger_path(assigns(:report_trigger))
  end

  test "should show report_trigger" do
    get :show, :id => @report_trigger.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @report_trigger.to_param
    assert_response :success
  end

  test "should update report_trigger" do
    put :update, :id => @report_trigger.to_param, :report_trigger => @report_trigger.attributes
    assert_redirected_to report_trigger_path(assigns(:report_trigger))
  end

  test "should destroy report_trigger" do
    assert_difference('ReportTrigger.count', -1) do
      delete :destroy, :id => @report_trigger.to_param
    end

    assert_redirected_to report_triggers_path
  end
end
