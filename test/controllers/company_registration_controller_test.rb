require "test_helper"

class CompanyRegistrationControllerTest < ActionDispatch::IntegrationTest
  test "should get input_company" do
    get input_company_path
    assert_response :success
    assert_template 'company_registration/input_company'
    assert_select 'form[method="post"][action=?]', input_company_path
    assert_select 'input[name=?]', 'company[name]'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  test "should get input_branch" do
    get input_branch_path
    assert_response :success
    assert_template 'company_registration/input_branch'
    assert_select 'form[method="post"][action=?]', input_branch_path
    assert_select 'input[name=?]', 'branch[name]'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  test "should get select_user" do
    get select_user_path
    assert_response :success
    assert_template "company_registration/select_user"
    assert_select 'form[method="post"][action=?]', selecter_path
    assert_select 'input[type="radio"][name=?][value="new"]', 'user_select'
    assert_select 'input[type="radio"][name=?][value="existing"]', 'user_select'
    assert_select 'input[type="submit"][name="commit"]'
  end
end
