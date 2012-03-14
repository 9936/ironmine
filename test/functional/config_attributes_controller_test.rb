require 'test_helper'

class ConfigAttributesControllerTest < ActionController::TestCase
  setup do
    @config_attribute = config_attributes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:config_attributes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create config_attribute" do
    assert_difference('ConfigAttribute.count') do
      post :create, config_attribute: @config_attribute.attributes
    end

    assert_redirected_to config_attribute_path(assigns(:config_attribute))
  end

  test "should show config_attribute" do
    get :show, id: @config_attribute.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @config_attribute.to_param
    assert_response :success
  end

  test "should update config_attribute" do
    put :update, id: @config_attribute.to_param, config_attribute: @config_attribute.attributes
    assert_redirected_to config_attribute_path(assigns(:config_attribute))
  end

  test "should destroy config_attribute" do
    assert_difference('ConfigAttribute.count', -1) do
      delete :destroy, id: @config_attribute.to_param
    end

    assert_redirected_to config_attributes_path
  end
end
