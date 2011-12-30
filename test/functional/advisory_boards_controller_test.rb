require 'test_helper'

class AdvisoryBoardsControllerTest < ActionController::TestCase
  setup do
    @advisory_board = advisory_boards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:advisory_boards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advisory_board" do
    assert_difference('AdvisoryBoard.count') do
      post :create, advisory_board: @advisory_board.attributes
    end

    assert_redirected_to advisory_board_path(assigns(:advisory_board))
  end

  test "should show advisory_board" do
    get :show, id: @advisory_board.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @advisory_board.to_param
    assert_response :success
  end

  test "should update advisory_board" do
    put :update, id: @advisory_board.to_param, advisory_board: @advisory_board.attributes
    assert_redirected_to advisory_board_path(assigns(:advisory_board))
  end

  test "should destroy advisory_board" do
    assert_difference('AdvisoryBoard.count', -1) do
      delete :destroy, id: @advisory_board.to_param
    end

    assert_redirected_to advisory_boards_path
  end
end
