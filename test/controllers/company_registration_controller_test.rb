require "test_helper"

class CompanyRegistrationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @company_name = "company"
    @branch_name = "branch"
  end
  
  test "should get new" do
    get new_company_registration_path
    assert_response :success
    assert_template 'company_registration/new'
    assert_select 'form[method="post"][action=?]', company_registration_index_path
    assert_select 'input[name=?]', 'company[name]'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  # createメソッド
  test "post company_registration_index_path" do
    # 不適切な会社名を送信
    post company_registration_index_path, params: { company: { name: "" } }
    assert_template 'company_registration/new'    
    
    # 適切な会社名を送信
    post company_registration_index_path, params: { company: { name: @company_name } }
    assert_equal @company_name, session[:company_registration][:company][:name]
    assert_template "company_registration/new_branch"
    assert_select 'form[method="post"][action=?]', create_branch_company_registration_index
    assert_select 'input[name=?]', 'branch[name]'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  # create_branchメソッド
  test "post create_branch_company_registration_index_path" do
    session[:company_registration][:company][:name] = @company_name
    
    # 不適切な支店名を送信
    post create_branch_company_registration_index_path, params: { branch: { name: "" } }
    assert_template "company_registration/new_branch"
    
    # 適切な支店名を送信
    post create_branch_company_registration_index_path, params: { branch: { name: @branch_name } }
    assert_equal @branch_name, session[:company_registration][:branch][:name]
    assert_template "company_registration/user_select"
    assert_select 'form[type="post][action=?]', create_user_select_company_registration_index
    assert_select 'input[type="radio"][name=?][value="new"]', 'user_select'
    assert_select 'input[type="radio"][name=?][value="existing"]', 'user_select'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  # create_user_selectメソッド
  # test "post create_user_select_company_registration_index" do
  #   session[:company_registration][:company][:name] = @company_name
  #   session[:company_registration][:branch][:name] = @branch_name
    
  #   # 既存のユーザーを選択した時
  #   post create_user_select_company_registration_index, params: { user_select: 'existing' } }
  # end
end
