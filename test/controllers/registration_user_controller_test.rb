require "test_helper"

class RegistrationUserControllerTest < ActionDispatch::IntegrationTest
  test "should redirect new when invalid branch_id" do
    get new_user_registration_path(branch_id: invalid_id)
    assert_redirected_to root_url
  end
  
  test "get new" do
    get new_user_registration_path
    assert_response :success
    assert_template 'devise/registrations/new'
  end
  
  test "get new with branch_id" do 
    branch = branches(:branch)
    get new_user_registration_path(branch_id: branch.id)
    assert_response :success
    assert_template 'devise/registrations/new'
  end
  
  test "post user_registration_path" do
    assert_difference ->{ User.count } => 1, ->{ Company.count } => 0,  ->{ Branch.count } => 0 , ->{ Relationship.count } => 0 do
      post user_registration_path, params: { user: {  last_name: "example",
                                                          first_name: "test",
                                                          email: "test@example.com",
                                                          password: "password",
                                                          password_confirmation: "password" } }
    end
  end
end