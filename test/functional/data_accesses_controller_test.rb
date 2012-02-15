require 'test_helper'

class DataAccessesControllerTest < ActionController::TestCase
  setup do
    @data_access = data_accesses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:data_accesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create data_access" do
    assert_difference('DataAccess.count') do
      post :create, data_access: @data_access.attributes
    end

    assert_redirected_to data_access_path(assigns(:data_access))
  end

  test "should show data_access" do
    get :show, id: @data_access.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @data_access.to_param
    assert_response :success
  end

  test "should update data_access" do
    put :update, id: @data_access.to_param, data_access: @data_access.attributes
    assert_redirected_to data_access_path(assigns(:data_access))
  end

  test "should destroy data_access" do
    assert_difference('DataAccess.count', -1) do
      delete :destroy, id: @data_access.to_param
    end

    assert_redirected_to data_accesses_path
  end
end
