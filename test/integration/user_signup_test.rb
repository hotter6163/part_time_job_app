require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get new_user_path
    post users_path, params: { user: {  first_name: '',
                                        last_name: '',
                                        email: 'user@invalid', 
                                        password: 'foo',
                                        password_confirmation: 'bar'
                                      }
                              }
    assert_template 'users/new'
  end
  
  
end
