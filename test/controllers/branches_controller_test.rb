require "test_helper"

class BranchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    login_as(@user) 
    @admin_branch = Relationship.find_by(user: @user, admin: true).branch
    @not_admin_branch = Relationship.find_by(user: @user, admin: false).branch
  end
  
  test "should redirect show when not signin" do
    logout
    get branch_path(@admin_branch)
    assert_redirected_to new_user_session_path
  end
  
  test "should redirect show when not admin" do
    get branch_path(@not_admin_branch)
    assert_redirected_to root_url
  end
  
  # get show
  # adminユーザーだけ企業ページにアクセスできる
  test "should get show" do
    get branch_path(@admin_branch)
    assert_template "branches/show"
    assert_select "a[href=?]", add_employee_branch_path(@admin_branch)
  end
  
  # get add_employee
  test "should get add_employee" do 
    get add_employee_branch_path(@admin_branch)
    assert_select 'form[action=?]', send_email_branch_path(@admin_branch)
    assert_select 'input[name="email"]'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  # send_emailに不適切なメールアドレスが送信されたらリダイレクト
  test "should redirect send_email when send invalid email" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      assert_no_difference 'ActionMailer::Base.deliveries.size' do
        post send_email_branch_path(@admin_branch), params: { email: invalid_address }
      end
      assert_template 'branches/add_employee'
      assert_nil flash[:success]
      assert !!flash[:denger]
    end
  end
end
