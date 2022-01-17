require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  # ログインしてない状態でホームにアクセス
  test "should get home with logout" do
    get root_url
    assert_response :success
    assert_select 'a[href=?]', new_user_registration_path
    assert_select 'a[href=?]', input_company_path
  end
  
  # ログイン状態でホームにアクセス
  test "should get home with login" do
    user = users(:user)
    sign_in(user)
    sql = " select  relationships.master, 
                    relationships.admin, 
                    branches.name as branch_name,
                    branches.id as branch_id
            from  users 
                  inner join relationships on users.id = relationships.user_id 
                  inner join branches on relationships.branch_id = branches.id 
            where user_id = #{user.id}"
    branches = ActiveRecord::Base.connection.select_all(sql)
    branches.each do |branch|
      assert_match branch["branch_name"], response.body
      if branch["admin"] == 1
        assert_select "a[href=?]", branch_path(branch["branch_id"])
      end
    end
  end
end
