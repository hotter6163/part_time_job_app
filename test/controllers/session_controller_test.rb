require "test_helper"

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "post user_session_path" do
    user = users(:user1)
    assert_no_difference ['Company.count', 'Branch.count', 'Relationship.count'] do
      post user_session_path, params: { user: { email: user.email,
                                                password: 'password' } }
    end
    assert_equal 302, response.status
  end
  
  test "get new_user_session" do 
    get new_user_session_path
    assert_response :success
    assert_select 'form[action=?]', user_session_path
    assert_select 'input[type=email][name=?]', 'user[email]'
    assert_select 'input[type=password][name=?]', 'user[password]'
    assert_select 'input[type="submit"][name="commit"]'
  end
end