require "test_helper"

class CompanyRegistrationTest < ActionDispatch::IntegrationTest
  test "company_registration" do
    get new_company_registration_path
    
    # 不適切な会社名を送信
    post company_registration_index_path, params: { company: { name: "" } }
    assert_template 'company_registration/new'    
    
    # 適切な会社名を送信
    company_name = "company"
    post company_registration_index_path, params: { company: { name: company_name } }
    assert_equal company_name, session[:company_registration][:company][:name]
    assert_template "company_registration/new_branch"
    assert_select 'form[method="post"][action=?]', create_branch_company_registration_index_path
    assert_select 'input[name=?]', 'branch[name]'
    assert_select 'input[type="submit"][name="commit"]'
  
    # 不適切な支店名を送信
    post create_branch_company_registration_index_path, params: { branch: { name: "" } }
    assert_template "company_registration/new_branch"
    
    # 適切な支店名を送信
    branch_name = 'branch'
    post create_branch_company_registration_index_path, params: { branch: { name: branch_name } }
    assert_equal branch_name, session[:company_registration][:branch][:name]
    assert_template "company_registration/user_select"
    assert_select 'form[method="post"][action=?]', user_select_company_registration_index_path
    assert_select 'input[type="radio"][name=?][value="new"]', 'user_select'
    assert_select 'input[type="radio"][name=?][value="existing"]', 'user_select'
    assert_select 'input[type="submit"][name="commit"]'
  end
end
