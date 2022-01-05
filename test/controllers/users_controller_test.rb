require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
  end
  
  test "should get new" do
    get new_user_path
    assert_response :success
    
    # ユーザー情報の入力フォームがあるか
    assert_select 'form[action=?]', users_path
    assert_select 'input[name=?]', 'user[first_name]'
    assert_select 'input[name=?]', 'user[last_name]'
    assert_select 'input[name=?]', 'user[email]'
    assert_select 'input[name=?]', 'user[password]'
    assert_select 'input[name=?]', 'user[password_confirmation]'
  end

  test "should get show" do
    get user_path(@user)
    assert_response :success
  end
end
