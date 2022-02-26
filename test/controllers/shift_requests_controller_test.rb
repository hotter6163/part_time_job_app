require "test_helper"

class ShiftRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    login_as(@user)
  end
  
  # destroy
  # シフトの期限前、自分のシフト
  test "destroy shift_request before deadline and submitter" do
    shift_submission = shift_submissions(:seven)
    shift_request = shift_requests(:one)
    assert_difference "ShiftRequest.count", -1 do
      delete shift_submission_shift_request_path(shift_submission, shift_request)
    end
    assert_redirected_to shift_submission_path(shift_submission.period)
    follow_redirect!
    assert_no_match "<td>#{shift_request.date.strftime("%m/%d")}<\/td>", response.body
    assert_match "<td>#{shift_requests(:two).date.strftime("%m/%d")}<\/td>", response.body
  end
  
  # シフトの締切後、自分のシフト
  test "destroy shift_request after deadline and submitter" do
    shift_submission = shift_submissions(:one)
    shift_request = shift_requests(:five)
    assert_no_difference "ShiftRequest.count" do
      delete shift_submission_shift_request_path(shift_submission, shift_request)
    end
    assert_redirected_to root_url
  end
  
  # シフトの締め切り前、他人のシフト
  test "destroy shift_request before deadline and submitter is other" do
    shift_submission = shift_submissions(:two)
    shift_request = shift_requests(:seven)
    assert_no_difference "ShiftRequest.count" do
      delete shift_submission_shift_request_path(shift_submission, shift_request)
    end
    assert_redirected_to root_url
  end
end
