require 'test_helper'

class AdvisoryBoardMembersControllerTest < ActionController::TestCase
  setup do
    @advisory_board_member = advisory_board_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:advisory_board_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advisory_board_member" do
    assert_difference('AdvisoryBoardMember.count') do
      post :create, advisory_board_member: @advisory_board_member.attributes
    end

    assert_redirected_to advisory_board_member_path(assigns(:advisory_board_member))
  end

  test "should show advisory_board_member" do
    get :show, id: @advisory_board_member.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @advisory_board_member.to_param
    assert_response :success
  end

  test "should update advisory_board_member" do
    put :update, id: @advisory_board_member.to_param, advisory_board_member: @advisory_board_member.attributes
    assert_redirected_to advisory_board_member_path(assigns(:advisory_board_member))
  end

  test "should destroy advisory_board_member" do
    assert_difference('AdvisoryBoardMember.count', -1) do
      delete :destroy, id: @advisory_board_member.to_param
    end

    assert_redirected_to advisory_board_members_path
  end
end
