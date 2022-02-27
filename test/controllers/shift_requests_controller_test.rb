require "test_helper"

class ShiftRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    login_as(@user)
    @shift_submission = shift_submissions(:seven)
    @period = @shift_submission.period
  end
  
  #----------------------------------------------------------------
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
    assert_no_match "<td>#{shift_request.date.strftime("%m/%d")}", response.body
    assert_match "<td>#{shift_requests(:two).date.strftime("%m/%d")}", response.body
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
  
  #----------------------------------------------------------------
  # create
  # 【失敗】空欄で送信
  test "should redirect create when send blank params" do
    assert_no_difference "ShiftRequest.count" do
      post shift_submission_shift_requests_path(@shift_submission), params: { shift_request: {  date: "2030-03-10",
                                                                                                start_time: "",
                                                                                                end_time: "" } }
    end
    assert_redirected_to shift_submission_path(@period)
    assert !!flash[:danger]
  end
  
  # 【失敗】期間外の日付で送信
  test "should redirect create when date is out of period" do
    assert_no_difference "ShiftRequest.count" do
      post shift_submission_shift_requests_path(@shift_submission), params: { shift_request: {  date: "2029-03-10",
                                                                                                start_time: "14:00",
                                                                                                end_time: "21:00" } }
    end
    assert_redirected_to shift_submission_path(@period)
    assert !!flash[:danger]
  end
  
  # 【成功】新規の日付で送信
  test "create new shift_request" do 
    date = "2030-03-10"
    assert_difference "ShiftRequest.count", 1 do
      post shift_submission_shift_requests_path(@shift_submission), params: { shift_request: {  date: date,
                                                                                                start_time: "14:00",
                                                                                                end_time: "21:00" } }
    end
    assert_not !!flash[:danger]
    assert !!flash[:success]
    assert_redirected_to shift_submission_path(@period)
    follow_redirect!
    assert_match "<td>#{date.to_date.strftime("%m/%d")}", response.body
  end
  
  # 【成功】既に登録されている日付で送信
  test "update shift_request" do
    date = "2030-03-12"
    start_time = "09:00"
    end_time = "14:00"
    assert_no_difference "ShiftRequest.count" do
      post shift_submission_shift_requests_path(@shift_submission), params: { shift_request: {  date: date,
                                                                                                start_time: start_time,
                                                                                                end_time: end_time } }
    end
    assert_redirected_to shift_submission_path(@period)
    assert_not !!flash[:danger]
    assert !!flash[:success]
    shift_request = @shift_submission.shift_requests.find_by(date: date)
    assert !!shift_request
    assert_equal start_time, shift_request.start_time_of_30_hours_system
    assert_equal end_time, shift_request.end_time_of_30_hours_system
  end
end
