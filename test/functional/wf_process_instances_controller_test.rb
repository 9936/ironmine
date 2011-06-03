require 'test_helper'

class WfProcessInstancesControllerTest < ActionController::TestCase
  setup do
    @wf_process_instance = wf_process_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wf_process_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wf_process_instance" do
    assert_difference('WfProcessInstance.count') do
      post :create, :wf_process_instance => @wf_process_instance.attributes
    end

    assert_redirected_to wf_process_instance_path(assigns(:wf_process_instance))
  end

  test "should show wf_process_instance" do
    get :show, :id => @wf_process_instance.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @wf_process_instance.to_param
    assert_response :success
  end

  test "should update wf_process_instance" do
    put :update, :id => @wf_process_instance.to_param, :wf_process_instance => @wf_process_instance.attributes
    assert_redirected_to wf_process_instance_path(assigns(:wf_process_instance))
  end

  test "should destroy wf_process_instance" do
    assert_difference('WfProcessInstance.count', -1) do
      delete :destroy, :id => @wf_process_instance.to_param
    end

    assert_redirected_to wf_process_instances_path
  end
end
