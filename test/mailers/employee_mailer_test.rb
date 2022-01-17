require "test_helper"

class EmployeeMailerTest < ActionMailer::TestCase
  test "add_new_user" do
    mail = EmployeeMailer.add_new_user
    assert_equal "Add new user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "add_existing_user" do
    mail = EmployeeMailer.add_existing_user
    assert_equal "Add existing user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
