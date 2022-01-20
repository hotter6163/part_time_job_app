require "test_helper"

class EmployeeMailerTest < ActionMailer::TestCase
  def setup
    @branch = branches(:branch)
    @user = users(:user_have_no_relationship)
  end
  
  # 新規ユーザー用のメール
  test "add_new_user" do
    new_user_email = "new_user@example.com"
    mail = EmployeeMailer.add_new_user(@branch, new_user_email)
    assert_equal "#{@branch.company_name}から従業員登録の申請", mail.subject
    assert_equal [new_user_email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match new_user_registration_path(branch_id: @branch.id), mail.body.encoded
  end

  test "add_existing_user" do
    mail = EmployeeMailer.add_existing_user(@branch, @user)
    assert_equal "#{@branch.company_name}から従業員登録の申請", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match new_relationship_path(branch_id: @branch.id), mail.body.encoded
  end
end
