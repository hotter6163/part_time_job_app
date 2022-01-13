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
  
  # create_user_selectメソッド
  # test "post create_user_select_company_registration_index" do
  #   session[:company_registration][:company][:name] = @company_name
  #   session[:company_registration][:branch][:name] = @branch_name
    
  #   # 既存のユーザーを選択した時
  #   post create_user_select_company_registration_index, params: { user_select: 'existing' } }
  # end
end
