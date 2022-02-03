require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  # ログインしてない状態でホームにアクセス
  test "should get home with logout" do
    get root_url
    assert_response :success
    assert_select 'a[href=?]', new_user_registration_path
    assert_select 'a[href=?]', new_company_registration_path
  end
  
  # ログイン状態でホームにアクセス
  test "should get home with login" do
    user = users(:user)
    sign_in(user)
    get root_url
    branches = user.branches
    branches.each do |branch|
      assert_match branch.company_name, response.body
      if branch.relationships.find_by(user: user).admin?
        assert_select "a[href=?]", branch_path(branch)
      end
    end
  end
end
