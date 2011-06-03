require 'test_helper'

class WfStepInstancesControllerTest < ActionController::TestCase
  setup do
    @wf_step_instance = wf_step_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wf_step_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wf_step_instance" do
    assert_difference('WfStepInstance.count') do
      post :create, :wf_step_instance => @wf_step_instance.attributes
    end

    assert_redirected_to wf_step_instance_path(assigns(:wf_step_instance))
  end

  test "should show wf_step_instance" do
    get :show, :id => @wf_step_instance.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @wf_step_instance.to_param
    assert_response :success
  end

  test "should update wf_step_instance" do
    put :update, :id => @wf_step_instance.to_param, :wf_step_instance => @wf_step_instance.attributes
    assert_redirected_to wf_step_instance_path(assigns(:wf_step_instance))
  end

  test "should destroy wf_step_instance" do
    assert_difference('WfStepInstance.count', -1) do
      delete :destroy, :id => @wf_step_instance.to_param
    end

    assert_redirected_to wf_step_instances_path
  end
end
