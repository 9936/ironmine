require 'test_helper'

class OrganizationInfosControllerTest < ActionController::TestCase
  setup do
    @organization_info = organization_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_info" do
    assert_difference('OrganizationInfo.count') do
      post :create, organization_info: @organization_info.attributes
    end

    assert_redirected_to organization_info_path(assigns(:organization_info))
  end

  test "should show organization_info" do
    get :show, id: @organization_info.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_info.to_param
    assert_response :success
  end

  test "should update organization_info" do
    put :update, id: @organization_info.to_param, organization_info: @organization_info.attributes
    assert_redirected_to organization_info_path(assigns(:organization_info))
  end

  test "should destroy organization_info" do
    assert_difference('OrganizationInfo.count', -1) do
      delete :destroy, id: @organization_info.to_param
    end

    assert_redirected_to organization_infos_path
  end
end
