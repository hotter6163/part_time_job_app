require "test_helper"

class CompanyRegistrationTest < ActionDispatch::IntegrationTest
  test "company_registration with existing user" do
    get input_company_path
    
    # 不適切な会社名を送信
    post create_company_path, params: { company: { name: "" } }
    assert_template 'company_registration/input_company'
    
    # 適切な会社名を送信
    company_name = "company"
    post create_company_path, params: { company: { name: company_name } }
    assert_equal company_name, session[:company_registration][:company][:name]
    assert_redirected_to input_branch_path
    follow_redirect!
  
    # 不適切な支店名を送信
    post input_branch_path, params: { branch: { name: "" } }
    
    # 適切な支店名を送信
    branch_name = 'branch'
    post create_branch_path, params: { branch: { name: branch_name } }
    assert_equal branch_name, session[:company_registration][:branch][:name]
    assert_redirected_to select_user_path
    follow_redirect!
    
    # 既存のユーザーを選択
    post selecter_path, params: { user_select: "existing" }
    assert_redirected_to input_user_email_path
    follow_redirect!
    
    # 登録されていないEメールを送信
    post search_user_path, params: { email: "invalid@example.com" }
    assert_template "company_registration/input_user_email"
    
    # 登録されているEメールを送信
    user = users(:user1)
    assert_difference ['Company.count', 'Branch.count'], 1 do
      post search_user_path, params: { email: user.email }
    end
    assert_redirected_to new_user_session_path
  end
end
