require 'test_helper'

class ChangeApprovalsControllerTest < ActionController::TestCase
  setup do
    @change_approval = change_approvals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:change_approvals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create change_approval" do
    assert_difference('ChangeApproval.count') do
      post :create, change_approval: @change_approval.attributes
    end

    assert_redirected_to change_approval_path(assigns(:change_approval))
  end

  test "should show change_approval" do
    get :show, id: @change_approval.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @change_approval.to_param
    assert_response :success
  end

  test "should update change_approval" do
    put :update, id: @change_approval.to_param, change_approval: @change_approval.attributes
    assert_redirected_to change_approval_path(assigns(:change_approval))
  end

  test "should destroy change_approval" do
    assert_difference('ChangeApproval.count', -1) do
      delete :destroy, id: @change_approval.to_param
    end

    assert_redirected_to change_approvals_path
  end
end
