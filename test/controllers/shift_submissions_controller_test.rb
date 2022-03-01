require "test_helper"

class ShiftSubmissionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    @branch = branches(:branch)
    login_as(@user)
    @period = periods(:four)
    @valid_shift_submission_params = {
      period: @period.id,
      shift_request: {
        "0".to_sym => {
          date: "2030-02-24",
          start_time: "8:30",
          end_time: "14:00"
        },
        "1".to_sym => {
          date: "2030-02-27",
          start_time: "8:30",
          end_time: "14:00"
        },
        "2".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "3".to_sym => {
          date: "2030-03-05",
          start_time: "14:00",
          end_time: "21:00"
        },
        "4".to_sym => {
          date: "2030-03-01",
          start_time: "14:00",
          end_time: "19:00"
        },
        "5".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "6".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "7".to_sym => {
          date: "2030-02-25",
          start_time: "16:00",
          end_time: "21:00"
        },
        "8".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "9".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "10".to_sym => {
          date: "2030-03-03",
          start_time: "19:00",
          end_time: "02:00"
        },
        "11".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "12".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "13".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        }
      }
    }
    @error_nums = Set.new(["1", "4", "5", "6", "7", "8", "3", "9"])
    @num_of_displays = 10
    @invalid_shift_submission_params = {
      period: @period.id,
      shift_request: {
        # 有効
        "0".to_sym => {
          date: "2030-02-27",
          start_time: "8:30",
          end_time: "14:00"
        },
        # 日付が無効
        "1".to_sym => {
          date: "2029-12-31",
          start_time: "8:30",
          end_time: "14:00"
        },
        # すべて空欄
        "2".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        # 3, 4, 9シフト日重複
        "3".to_sym => {
          date: "2030-02-25",
          start_time: "08:30",
          end_time: "14:00"
        },
        "4".to_sym => {
          date: "2030-02-25",
          start_time: "08:30",
          end_time: "14:00"
        },
        # start_timeが空白
        "5".to_sym => {
          date: "2030-02-27",
          start_time: "",
          end_time: "14:00"
        },
        # start_timeよりend_timeの方が早い
        "6".to_sym => {
          date: "2030-03-01",
          start_time: "14:00",
          end_time: "09:00"
        },
        # dateが空白
        "7".to_sym => {
          date: "",
          start_time: "8:30",
          end_time: "14:00"
        },
        # end_timeが空白
        "8".to_sym => {
          date: "2030-02-27",
          start_time: "8:30",
          end_time: ""
        },
        "9".to_sym => {
          date: "2030-02-25",
          start_time: "08:30",
          end_time: "14:00"
        },
        "10".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "11".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "12".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "13".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        }
      }
    }
  end
  
  # ------------------------------------------------
  # get new_shift
  test "get new_shift" do
    get new_shift_submission_path(@period)
    assert_response :success
    assert_select 'form[action=?]', shift_submissions_path(@period)
    assert_select 'input[name=period][type=hidden]'
    @period.days.each { |date| assert_select 'option[value=?]', date.to_s }
    @period.days.count.times do |n|
      assert_select 'select[name=?]', "shift_request[#{n}][date]"
      assert_select 'input[type=time][name=?]', "shift_request[#{n}][start_time]"
      assert_select 'input[type=time][name=?]', "shift_request[#{n}][end_time]"
    end
    assert_select 'input[type=submit]'
  end
  
  # ログインしていなければリダイレクト
  test "should redirect new_shift when not login" do 
    logout
    get new_shift_submission_path(@branch)
    assert_response :redirect
  end
  
  # ログインユーザーがrelationship_idのユーザーではなかったらホームにリダイレクト
  test "should redirect new_shift when not correct_user" do
    other_period = periods(:six)
    get new_shift_submission_path(other_period)
    assert_redirected_to root_url
  end
  
  
  # ------------------------------------------------
  # post create_shift
  # 正しい値を送信
  test "post create_shift with valid_params" do 
    assert_difference -> { ShiftSubmission.count } => 1, -> { ShiftRequest.count } => 6 do
      post shift_submissions_path(@period), params: @valid_shift_submission_params
    end
    assert_template "shift_submissions/success"
  end
  
  # 締め切りが過ぎた期間を送信
  test "post create_shift with period after deadline" do
    @invalid_shift_submission_params[:period] = periods(:one).id
    assert_no_difference ['ShiftSubmission.count', 'ShiftRequest.count'] do
      post shift_submissions_path(@period), params: @invalid_shift_submission_params
    end
    assert_template "shift_submissions/new_shift"
  end
  
  # 別の企業の期間を送信
  test "post create_shift with ohter branch's period" do
    @invalid_shift_submission_params[:period] = periods(:five).id
    assert_no_difference ['ShiftSubmission.count', 'ShiftRequest.count'] do
      post shift_submissions_path(@period), params: @invalid_shift_submission_params
    end
    assert_template "shift_submissions/new_shift"
  end
  
  # 不適切なシフト希望を提出
  test "post create_shift with invalid_params" do
    assert_no_difference ['ShiftSubmission.count', 'ShiftRequest.count'] do
      post shift_submissions_path(@period), params: @invalid_shift_submission_params
    end
    assert_template "shift_submissions/new_shift"
    error_nums = assigns(:error_nums)
    @error_nums.each { |num| assert error_nums.include?(num) }
    @invalid_shift_submission_params[:shift_request].each do |key, value|
      next if value.values.all?(&:blank?)
      
      if value[:date].present? && @period.is_date_in?(value[:date].to_date)
        assert_select "select#select-#{key} option[value=?][selected]", value[:date]
      end
      assert_select "input#start-time-form-#{key}[value=?]", value[:start_time]
      assert_select "input#end-time-form-#{key}[value=?]", value[:end_time]
    end
  end
  
  
  # ------------------------------------------------
  # get show
  test "show shift_submission before deadline" do
    period = periods(:seven)
    get shift_submission_path(period)
    shift_submission = period.shift_submissions.find_by(user: @user)
    shift_requests = shift_submission.shift_requests.all
    assert_match period.start_to_end, response.body
    shift_requests.each do |shift_request|
      assert_match shift_request.date.strftime("%m/%d"), response.body
      assert_match shift_request.start_time_of_30_hours_system, response.body
      assert_match shift_request.end_time_of_30_hours_system, response.body
      assert_select 'a[href=?][data-method=delete]', shift_submission_shift_request_path(shift_submission, shift_request)
    end
    assert_select 'form[action=?]', shift_submission_shift_requests_path(shift_submission)
  end
  
  test "show shift_submission after deadline" do
    period = periods(:one)
    get shift_submission_path(period)
    shift_submission = period.shift_submissions.find_by(user: @user)
    shift_requests = shift_submission.shift_requests.all
    assert_match period.start_to_end, response.body
    shift_requests.each do |shift_request|
      assert_match shift_request.date.strftime("%m/%d"), response.body
      assert_match shift_request.start_time_of_30_hours_system, response.body
      assert_match shift_request.end_time_of_30_hours_system, response.body
      assert_select 'a[href=?][data-method=delete]', shift_submission_shift_request_path(shift_submission, shift_request), 0
    end
    assert_select 'form[action=?]', shift_submission_shift_requests_path(shift_submission), 0
  end
end
