require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Example", last_name: "User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  # 正しい場合、保存できるか
  test "should be valid" do
    assert @user.valid?
  end

  # 名が空白でないか
  test "first_name should be present" do
    @user.first_name = "     "
    assert_not @user.valid?
  end
  
  # 姓が空白でないか
  test "last_name should be present" do
    @user.last_name = "     "
    assert_not @user.valid?
  end

  # メールアドレスが空白でないか
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  # 名の長さが50字以内か
  test "first_name should not be too long" do
    @user.first_name = "a" * 51
    assert_not @user.valid?
  end
  
  # 姓の長さが50字以内か
  test "last_name should not be too long" do
    @user.last_name = "a" * 51
    assert_not @user.valid?
  end
end
