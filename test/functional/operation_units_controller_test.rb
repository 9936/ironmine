require 'test_helper'

class OperationUnitsControllerTest < ActionController::TestCase
  setup do
    @operation_unit = operation_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:operation_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create operation_unit" do
    assert_difference('OperationUnit.count') do
      post :create, :operation_unit => @operation_unit.attributes
    end

    assert_redirected_to operation_unit_path(assigns(:operation_unit))
  end

  test "should show operation_unit" do
    get :show, :id => @operation_unit.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @operation_unit.to_param
    assert_response :success
  end

  test "should update operation_unit" do
    put :update, :id => @operation_unit.to_param, :operation_unit => @operation_unit.attributes
    assert_redirected_to operation_unit_path(assigns(:operation_unit))
  end

  test "should destroy operation_unit" do
    assert_difference('OperationUnit.count', -1) do
      delete :destroy, :id => @operation_unit.to_param
    end

    assert_redirected_to operation_units_path
  end
end
