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
end