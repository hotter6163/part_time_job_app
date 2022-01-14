require "test_helper"

class RegistrationUserControllerTest < ActionDispatch::IntegrationTest
  test "post user_registration_path" do
    assert_difference ->{ User.count } => 1, ->{ Company.count } => 0,  ->{ Branch.count } => 0 do
      post user_registration_path, params: { user: {  last_name: "example",
                                                          first_name: "test",
                                                          email: "test@example.com",
                                                          password: "password",
                                                          password_confirmation: "password" } }
    end
  end
end