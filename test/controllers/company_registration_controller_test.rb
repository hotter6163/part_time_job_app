require "test_helper"

class CompanyRegistrationControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_company_registration_path
    assert_response :success
    assert_template 'company_registration/new'
    assert_select 'form[method="post"][action=?]', company_registration_index_path
    assert_select 'input[name=?]', 'company[name]'
    assert_select 'input[name=?]', 'company[branch][name]'
    assert_select 'input[type="radio"][name=?][value="new"]', 'company[master][user]'
    assert_select 'input[type="radio"][name=?][value="existing"]', 'company[master][user]'
    assert_select 'input[name=?]', 'company[master][email]'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  # 既存のユーザーを選択、企業名が正しくない
  test "should redirect create when company_name is blank" do
    assert_no_difference ['Company.count', 'Branch.count'] do
      post company_registration_index_path,
        params:  { company:  {  name: "",
                                branch: { name: "branch" },
                                master: { user: "existing",
                                          email: "hotta-nagoya-6163@au.com" }
                              }
                  }
    end
    assert_template 'company_registration/new'
  end
  
  # 既存のユーザーを選択、支店名が正しくない
  test "should redirect create when branch_name is blank" do
    assert_no_difference ['Company.count', 'Branch.count'] do
      post company_registration_index_path,
        params:  { company:  {  name: "company",
                                branch: { name: "" },
                                master: { user: "existing",
                                          email: "hotta-nagoya-6163@au.com" }
                              }
                  }
    end
    assert_template 'company_registration/new'
  end
  
  # 既存のユーザーを選択、ユーザーが見つからない
  test "should redirect create when existing user don't find" do
    assert_no_difference ['Company.count', 'Branch.count'] do
      post company_registration_index_path,
        params:  { company:  {  name: "company",
                                branch: { name: "branch" },
                                master: { user: "existing",
                                          email: "hogehoge@au.com" }
                              }
                  }
    end
    assert_template 'company_registration/new'
  end
end
