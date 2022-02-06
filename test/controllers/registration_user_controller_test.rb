require "test_helper"

class RegistrationUserControllerTest < ActionDispatch::IntegrationTest
  # 普通にget
  test "get new" do
    get new_user_registration_path
    assert_response :success
    assert_template 'devise/registrations/new'
    assert_nil response.body.match(/name=\"branch_id\"/)
    assert_select 'input[type=text][name=?]', 'user[last_name]'
    assert_select 'input[type=text][name=?]', 'user[first_name]'
    assert_select 'input[type=email][name=?]', 'user[email]'
    assert_select 'input[type=password][name=?]', 'user[password]'
    assert_select 'input[type=password][name=?]', 'user[password_confirmation]'
  end
  
  # 普通にユーザー登録 post create
  test "post user_registration_path" do
    assert_difference ->{ User.count } => 1, ->{ Company.count } => 0,  ->{ Branch.count } => 0 , ->{ Relationship.count } => 0 do
      post user_registration_path, params: { user: {  last_name: "example",
                                                      first_name: "test",
                                                      email: "test@example.com",
                                                      password: "password",
                                                      password_confirmation: "password" } }
    end
    assert_redirected_to root_url
  end
end