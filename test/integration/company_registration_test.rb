require "test_helper"

class CompanyRegistrationTest < ActionDispatch::IntegrationTest
  def setup
    @company_name = "test_company"
    @branch_name = "test_branch"
  end
  
  test "company_registration with existing user" do
    get input_company_path
    
    # 不適切な会社名を送信
    post create_company_path, params: { company: { name: "" } }
    assert_template 'company_registration/input_company'
    
    # 適切な会社名を送信
    post create_company_path, params: { company: { name: @company_name } }
    assert_equal @company_name, session[:company_registration][:company][:name]
    assert_redirected_to input_branch_path
    follow_redirect!
  
    # 不適切な支店名を送信
    post input_branch_path, params: { branch: { name: "" } }
    
    # 適切な支店名を送信
    post create_branch_path, params: { branch: { name: @branch_name } }
    assert_equal @branch_name, session[:company_registration][:branch][:name]
    assert_redirected_to select_user_path
    follow_redirect!
    
    # 既存のユーザーを選択
    post selecter_path, params: { user_select: "existing" }
    assert_redirected_to new_user_session_path
    follow_redirect!
    
    # 誤ったログイン情報を送信
    assert_no_difference ['Company.count', 'Branch.count', 'Relationship.count'] do
      post user_session_path, params: { user: { email: 'wrong@example.com',
                                                password: 'password' } }
    end
    assert !!session[:company_registration]
    
    # 正しいログイン情報を送信
    user = users(:user1)
    assert_difference ['Company.count', 'Branch.count', 'Relationship.count'], 1 do
      post user_session_path, params: { user: { email: user.email,
                                                password: 'password' } }
    end
    assert_nil session[:company_registration]
  end
  
  test "company_registration with new user" do
    get input_company_path
    post create_company_path, params: { company: { name: @company_name } }
    post create_branch_path, params: { branch: { name: @branch_name } }
    
    # 新規のユーザーを選択
    post selecter_path, params: { user_select: "new" }
    assert_redirected_to new_user_registration_path
    follow_redirect!
    
    # ユーザーの情報に誤りがある
    assert_no_difference ['User.count', 'Company.count', 'Branch.count', 'Relationship.count'] do
      post user_registration_path, params: { user: {  last_name: "  ",
                                                      first_name: "  ",
                                                      email: "test@example",
                                                      password: "password",
                                                      password_confirmation: "pass" } }
    end
    assert !!session[:company_registration]
    
    # 正しいユーザー情報を送信
    assert_difference ['User.count', 'Company.count', 'Branch.count', 'Relationship.count'], 1 do
      post user_registration_path, params: { user: {  last_name: "example",
                                                          first_name: "test",
                                                          email: "test@example.com",
                                                          password: "password",
                                                          password_confirmation: "password" } }
    end
    assert_nil session[:company_registration]
  end
end
