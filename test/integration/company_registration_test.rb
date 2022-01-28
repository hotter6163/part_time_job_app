require "test_helper"

class CompanyRegistrationTest < ActionDispatch::IntegrationTest
  def setup
    @company_name = "test_company"
    @branch_name = "test_branch"
  end
  
  test "test" do 
    user = users(:user)
    sign_in user
    byebug
  end
  
end
