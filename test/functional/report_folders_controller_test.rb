require 'test_helper'

class ReportFoldersControllerTest < ActionController::TestCase
  setup do
    @report_folder = report_folders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_folders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_folder" do
    assert_difference('ReportFolder.count') do
      post :create, :report_folder => @report_folder.attributes
    end

    assert_redirected_to report_folder_path(assigns(:report_folder))
  end

  test "should show report_folder" do
    get :show, :id => @report_folder.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @report_folder.to_param
    assert_response :success
  end

  test "should update report_folder" do
    put :update, :id => @report_folder.to_param, :report_folder => @report_folder.attributes
    assert_redirected_to report_folder_path(assigns(:report_folder))
  end

  test "should destroy report_folder" do
    assert_difference('ReportFolder.count', -1) do
      delete :destroy, :id => @report_folder.to_param
    end

    assert_redirected_to report_folders_path
  end
end
