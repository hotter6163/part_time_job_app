require "test_helper"

class CompanyRegistrationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @company_name = "test_company"
    @branch_name = "test_branch"
  end
  
  # get input_company_path
  test "should get input_company" do
    get input_company_path
    assert_response :success
    assert_template 'company_registration/input_company'
    assert_select 'form[method="post"][action=?]', input_company_path
    assert_select 'input[name=?]', 'company[name]'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  # get input_branch_path
  test "should get input_branch when have company_name" do
    post create_company_path, params: { company: { name: @company_name } }
    get input_branch_path
    assert_response :success
    assert_template 'company_registration/input_branch'
    assert_select 'form[method="post"][action=?]', input_branch_path
    assert_select 'input[name=?]', 'branch[name]'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  # get input_company_path
  test "should get select_user when have company_name and branch_name" do
    post create_company_path, params: { company: { name: @company_name } }
    post create_branch_path, params: { branch: { name: @branch_name } }
    get select_user_path
    assert_response :success
    assert_template "company_registration/select_user"
    assert_select 'form[method="post"][action=?]', selecter_path
    assert_select 'input[type="radio"][name=?][value="new"]', 'user_select'
    assert_select 'input[type="radio"][name=?][value="existing"]', 'user_select'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  # 企業情報を持っていないとリダイレクト
  # get input_branch_path
  test "should redirect input_branch when have no company_name" do
    get input_branch_path
    assert_redirected_to input_company_path
  end
  
  # 企業情報を持っていないとリダイレクト
  # post create_branch_path
  test "should redirect create_branch when have no company_name" do
    post create_branch_path, params: { branch: { name: @branch_name } }
    assert_redirected_to input_company_path
  end
  
  # 企業情報を持っていないとリダイレクト
  # get select_user_path
  test "should redirect select_user when have no company_name" do
    get select_user_path
    assert_redirected_to input_company_path
  end
  
  # 企業情報を持っていないとリダイレクト
  # post selecter_path, params: { user_select: "new" }
  test "should redirect selecter when have no company_name" do
    post selecter_path, params: { user_select: "new" }
    assert_redirected_to input_company_path
  end
  
  # 支店情報を持っていないとリダイレクト
  # get select_user_path
  test "should redirect select_user when have company_name and no branch_name" do
    post create_company_path, params: { company: { name: @company_name } }
    get select_user_path
    assert_redirected_to input_branch_path
  end
  
  # 支店情報を持っていないとリダイレクト
  # post selecter_path, params: { user_select: "new" }
  test "should redirect selecter when have company_name and no branch_name" do
    post create_company_path, params: { company: { name: @company_name } }
    post selecter_path, params: { user_select: "new" }
    assert_redirected_to input_branch_path
  end
end
