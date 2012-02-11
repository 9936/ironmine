require 'test_helper'

class SessionTimesControllerTest < ActionController::TestCase
  setup do
    @session_time = session_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:session_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create session_time" do
    assert_difference('SessionTime.count') do
      post :create, session_time: @session_time.attributes
    end

    assert_redirected_to session_time_path(assigns(:session_time))
  end

  test "should show session_time" do
    get :show, id: @session_time.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @session_time.to_param
    assert_response :success
  end

  test "should update session_time" do
    put :update, id: @session_time.to_param, session_time: @session_time.attributes
    assert_redirected_to session_time_path(assigns(:session_time))
  end

  test "should destroy session_time" do
    assert_difference('SessionTime.count', -1) do
      delete :destroy, id: @session_time.to_param
    end

    assert_redirected_to session_times_path
  end
end
