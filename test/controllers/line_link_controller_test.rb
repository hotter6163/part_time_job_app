require "test_helper"

class LineLinkControllerTest < ActionDispatch::IntegrationTest
  def setup
    @line_link_before_deadline = line_links(:before_deadline)
    @line_link_after_deadline = line_links(:after_deadline)
    @correct_user = users(:user)
    @incorrect_user = users(:user1)
    @delete_token = "delete_token"
    login_as(@correct_user)
  end
  
  # beforeフィルターの検証
  # 成功
  test "get check_delete_link_path" do 
    get check_delete_link_path(@line_link_before_deadline, delete_token: @delete_token)
    assert_response :success
    assert_select 'form[action=?]', delete_link_path(@line_link_before_deadline)
    assert_select 'input[type=hidden][name=_method][value=delete]'
    assert_select 'input[type=hidden][value=?][name=delete_token]', @delete_token
    assert_select 'input[type=submit]'
  end
  
  # ログインしていない
  test "redirect when not log in" do 
    logout
    get check_delete_link_path(@line_link_before_deadline, delete_token: @delete_token)
    assert_redirected_to new_user_session_path
  end
  
  # 存在しないIDを送信
  test "redirect when not exist id" do 
    id = invalid_id(LineLink)
    get check_delete_link_path(id, delete_token: @delete_token)
    assert_redirected_to root_url
  end
  
  # 有効期限切れ
  test "redirect when login at 30 minutes later" do 
    get check_delete_link_path(@line_link_after_deadline, delete_token: @delete_token)
    assert_redirected_to root_url
  end
  
  # 違うユーザー
  test "redirect when incorrect_user" do 
    logout
    login_as(@incorrect_user)
    get check_delete_link_path(@line_link_after_deadline, delete_token: @delete_token)
    assert_redirected_to root_url
  end
  
  # 間違ったトークン
  test "redirect when invalid_token" do 
    get check_delete_link_path(@line_link_after_deadline, delete_token: "invalid_token")
    assert_redirected_to root_url
  end
end
