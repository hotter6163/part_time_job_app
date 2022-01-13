require "test_helper"

class CompanyRegistrationTest < ActionDispatch::IntegrationTest
  test "company_registration with existing user" do
    get input_company_company_registration_path
    
    # 不適切な会社名を送信
    post create_company_company_registration_path, params: { company: { name: "" } }
    assert_template 'company_registration/input_company'
    
    # 適切な会社名を送信
    company_name = "company"
    post create_company_company_registration_path, params: { company: { name: company_name } }
    assert_equal company_name, session[:company_registration][:company][:name]
    assert_redirected_to input_branch_company_registration_path
    follow_redirect!
  
    # 不適切な支店名を送信
    post input_branch_company_registration_path, params: { branch: { name: "" } }
    
    # 適切な支店名を送信
    branch_name = 'branch'
    post create_branch_company_registration_path, params: { branch: { name: branch_name } }
    assert_equal branch_name, session[:company_registration][:branch][:name]
    assert_redirected_to select_user_company_registration_path
    follow_redirect!
    
    # 既存のユーザーを選択
    
  end
end
