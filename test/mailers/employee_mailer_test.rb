require "test_helper"

class EmployeeMailerTest < ActionMailer::TestCase
  def setup
    @branch = branches(:branch)
    @user = users(:user_have_no_relationship)
    @token = RelationshipDigest.new_token
  end
  
  # 新規ユーザー用のメール
  test "add_new_user" do
    new_user_email = "new_user@example.com"
    mail = EmployeeMailer.add_new_user(@branch, @token, new_user_email)
    assert_equal "#{@branch.company_name}から従業員登録の申請", mail.subject
    assert_equal [new_user_email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match @token, mail.body.encoded
    assert_match @branch.id.to_s, mail.body.encoded
    assert_match CGI.escape(new_user_email), mail.body.encoded
    assert_match "/users/sign_up", mail.body.encoded
  end

  test "add_existing_user" do
    mail = EmployeeMailer.add_existing_user(@branch, @token, @user)
    assert_equal "#{@branch.company_name}から従業員登録の申請", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match @token, mail.body.encoded
    assert_match @branch.id.to_s, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
    assert_match "/relationships/new", mail.body.encoded
  end
end
