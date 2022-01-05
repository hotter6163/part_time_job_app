require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get new_user_path
    first_name = 'foo'
    last_name = 'bar'
    invalid_email = 'user@invalid'
    invalid_password = 'foo'
    invalid_password_confirmation = "bar"
    post users_path, params: { user: {  first_name: first_name,
                                        last_name: last_name,
                                        email: invalid_email, 
                                        password: invalid_password,
                                        password_confirmation: invalid_password_confirmation
                                      }
                              }
    assert_template 'users/new'
    assert_select 'form[action=?]', users_path
    assert_select 'input[name=?][value=?]', 'user[first_name]', first_name
    assert_select 'input[name=?][value=?]', 'user[last_name]', last_name
    assert_select 'input[name=?][value=?]', 'user[email]', invalid_email
    assert_select 'div#error_explanation'
  end
  
  
end
