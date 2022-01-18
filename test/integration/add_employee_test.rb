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
    get add_employee_branch_path(@branch)
    post send_email_branch_path(@branch), params: { email: 'new_user@example.com' }
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert !!flash[:success]
    assert_template "branches/send_email"
    
    logout
    get new_user_registration_path(branch_id: @branch.id)
    assert_select "input[name=branch_id][type=hidden][value=?]", @branch.id.to_s
    
    assert_difference ["User.count", "Relationship.count"], 1 do
      post user_registration_path, params: { user: {  last_name: "example",
                                                      first_name: "test",
                                                      email: "test@example.com",
                                                      password: "password",
                                                      password_confirmation: "password" },
                                              branch_id: @branch.id }
    end
    relationship = assigns(:relationship)
    assert_equal @branch.id, relationship.branch_id
    assert_not relationship.master
    assert_not relationship.admin
  end
  
  # ユーザー登録済みの従業員を登録
  test "add employee who is existing user" do
    get add_employee_branch_path(@branch)
    post send_email_branch_path(@branch), params: { email: @employee.email }
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert !!flash[:success]
    assert_template "branches/send_email"
    
    get new_relationship_path(branch_id: @branch.id)
    assert_template "relationships/new"
    assert_select 'form[action=?]', relationships_path
    assert_select 'input[name=branch_id][type=hidden][value=?]', @branch.id.to_s
    
    assert_difference 'Relationship.count' do
      post relationships_path, params: { branch_id: @branch.id }
    end
    relationship = assigns(:relationship)
    assert_equal @branch.id, relationship.branch_id
    assert_not relationship.master
    assert_not relationship.admin
  end
end
