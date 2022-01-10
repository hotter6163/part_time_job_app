require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  def setup
    @first_name = "foo"
    @last_name = "bar"
    @email = "foobar@example.com"
    @password = "password"
    @password_confirmation = "password"
  end
  
  # 正しくないparamsでは保存されない
  test "should not save User when invalid params" do
    get new_user_registration_path
    @email = "foobar@"
    assert_no_difference "User.count", 1 do
      post user_registration_path, params: { user: {  first_name: @first_name,
                                                      last_name: @last_name,
                                                      email: @email,
                                                      password: @password,
                                                      password_confirmation: @password_confirmation } }
    end
    assert_template "devise/registrations/new"
    assert_select "input[name=?][value=?]", "user[last_name]", @last_name
    assert_select "input[name=?][value=?]", "user[first_name]", @first_name
    assert_select "input[name=?][value=?]", "user[email]", @email
  end
    
    
  test "User signup" do 
    get new_user_registration_path
    
    # 登録ページに必要な要素があるか
    assert_select "form[action=?]", user_registration_path
    assert_select "input[type=submit]"
    assert_select "input[name=?]", "user[last_name]"
    assert_select "input[name=?]", "user[first_name]"
    assert_select "input[name=?]", "user[email]"
    assert_select "input[name=?]", "user[password]"
    assert_select "input[name=?]", "user[password_confirmation]"
    
    assert_difference "User.count", 1 do
      post user_registration_path, params: { user: {  first_name: @first_name,
                                                      last_name: @last_name,
                                                      email: @email,
                                                      password: @password,
                                                      password_confirmation: @password_confirmation } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert is_logged_in?(response.body)
  end
end

