require "test_helper"

class CompanyRegistrationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @company_name = "test_company"
    @branch_name = "test_branch"
  end
  
  test "should get new" do 
    get new_company_registration_path
    assert_response :success
    # 共通フォーム
    assert_select 'form[action=?]', company_registration_path
    assert_select 'input[name=?]', 'company_registration[company][name]'
    assert_select 'input[name=?]', 'company_registration[branch][name]'
    assert_select 'input[name=?]', 'company_registration[branch][name]'
  end
end
