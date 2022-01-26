require "test_helper"

class CompanyRegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @company_name = "test_company"
    @branch_name = "test_branch"
  end
  
  test "should get new" do 
    get new_company_registration_path
    assert_response :success
    # 共通フォーム
    assert_select 'form[action=?]', company_registrations_path
    assert_select 'input[name=?]', 'company[name]'
    assert_select 'input[name=?]', 'branch[name]'
    assert_select 'input[type=time][name=?]', 'branch[start_of_business_hours]'
    assert_select 'input[type=time][name=?]', 'branch[end_of_business_hours]'
  end
end
