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

  # メールアドレスの長さが255字以内か
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # 適切なメールアドレスが通過するか
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  # 不適切なメールアドレスが通過しないか
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # メールアドレスの一意性
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  # パスワードが空白でないか
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # パスワードが長すぎないか
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
