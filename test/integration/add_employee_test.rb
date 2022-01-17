require "test_helper"

class AddEmployeeTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    @branch = Relationship.find_by(user: @user, admin: true).branch
    login_as(@user)
    @employee = users(:user_have_no_relationship)
    ActionMailer::Base.deliveries.clear
  end
  
  # ユーザー登録していない従業員を登録
  test "add employee who is new user" do
    get add_employee_branch_path(@branch)
    post send_email_branch_path(@branch), params: { email: 'new_user@example.com' }
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
  
  # ユーザー登録済みの従業員を登録
  test "add employee who is existing user" do
    get add_employee_branch_path(@branch)
    post send_email_branch_path(@branch), params: { email: @employee.email }
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end
