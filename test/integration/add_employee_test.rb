require "test_helper"

class AddEmployeeTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    @branch = branches(:branch)
    login_as(@user)
    @employee = users(:user_have_no_relationship)
    ActionMailer::Base.deliveries.clear
  end
  
  # ユーザー登録していない従業員を登録
  test "add employee who is new user" do
    email = 'new_user@example.com'
    get add_employee_branch_path(@branch)
    assert_difference "RelationshipDigest.count", 1 do
      post send_email_branch_path(@branch), params: { email: email }
    end
    branch = assigns(:branch)
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert !!flash[:success]
    assert_template "branches/send_email"
    
    logout
    
    # 正しいトークンでアクセス
    get new_user_registration_path(token: branch.relationship_token, email: email, branch_id: @branch.id)
    assert_response :success
    assert_template "devise/registrations/new"
    assert_select "input[name=token][type=hidden][value=?]", branch.relationship_token
    assert_select "input[name=email][type=hidden][value=?]", email
    
    assert_difference "User.count", 1 do
      post user_registration_path, params: { user: {  last_name: "example",
                                                      first_name: "test",
                                                      email: email,
                                                      password: "password",
                                                      password_confirmation: "password" },
                                              token: branch.relationship_token,
                                              email: email,
                                              branch_id: @branch.id
      }
    end
    assert_redirected_to new_relationship_path(token: branch.relationship_token, email: email, branch_id: @branch.id)
    
    follow_redirect!
    assert_template "relationships/new"
    assert_select "form[action=?]", relationships_path
    assert_select "input[name=token][type=hidden][value=?]", branch.relationship_token
    assert_select "input[name=email][type=hidden][value=?]", email
    assert_select "input[name=branch_id][type=hidden][value=?]", @branch.id.to_s
    assert_select "input[type=submit][name=commit]"
    
    assert_difference "Relationship.count", 1 do
      post relationships_path, params: {  token: branch.relationship_token,
                                          email: email,
                                          branch_id: @branch.id
      }
    end
    relationship = assigns(:relationship)
    assert_equal relationship.branch_id, branch.id
    assert_not relationship.admin?
    assert_not relationship.master?
    relationship_digest = assigns(:relationship_digest)
    relationship_digest.reload
    assert relationship_digest.used?
    
    assert_redirected_to root_url
    follow_redirect!
    assert_match branch.company_name, response.body
  end
  
  # ユーザー登録済みの従業員を登録
  test "add employee who is existing user" do
    get add_employee_branch_path(@branch)
    post send_email_branch_path(@branch), params: { email: @employee.email }
    branch = assigns(:branch)
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert !!flash[:success]
    assert_template "branches/send_email"
    
    logout
    
    login_as(@employee)
    get new_relationship_path(token: branch.relationship_token, email: @employee.email, branch_id: @branch.id)
    assert_template "relationships/new"
    assert_select "form[action=?]", relationships_path
    assert_select "input[name=token][type=hidden][value=?]", branch.relationship_token
    assert_select "input[name=email][type=hidden][value=?]", @employee.email
    assert_select "input[name=branch_id][type=hidden][value=?]", @branch.id.to_s
    assert_select "input[type=submit][name=commit]"
    
    assert_difference "Relationship.count", 1 do
      post relationships_path, params: {  token: branch.relationship_token,
                                          email: @employee.email,
                                          branch_id: @branch.id
      }
    end
    relationship = assigns(:relationship)
    assert_equal branch.id, relationship.branch_id
    assert_equal @employee.email, relationship.user.email
    assert_not relationship.admin?
    assert_not relationship.master?
    relationship_digest = assigns(:relationship_digest)
    relationship_digest.reload
    assert relationship_digest.used?
    
    assert_redirected_to root_url
    follow_redirect!
    assert_match branch.company_name, response.body
  end
end
