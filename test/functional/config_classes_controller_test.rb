require 'test_helper'

class ConfigClassesControllerTest < ActionController::TestCase
  setup do
    @config_class = config_classes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:config_classes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create config_class" do
    assert_difference('ConfigClass.count') do
      post :create, config_class: @config_class.attributes
    end

    assert_redirected_to config_class_path(assigns(:config_class))
  end

  test "should show config_class" do
    get :show, id: @config_class.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @config_class.to_param
    assert_response :success
  end

  test "should update config_class" do
    put :update, id: @config_class.to_param, config_class: @config_class.attributes
    assert_redirected_to config_class_path(assigns(:config_class))
  end

  test "should destroy config_class" do
    assert_difference('ConfigClass.count', -1) do
      delete :destroy, id: @config_class.to_param
    end

    assert_redirected_to config_classes_path
  end
end
