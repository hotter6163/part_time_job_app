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
        "3".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
        },
        "4".to_sym => {
          date: "",
          start_time: "",
          end_time: ""
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
          date: "",
          start_time: "",
          end_time: ""
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

  test "get new_shift" do
    get new_shift_submission_path(@branch)
    assert_response :success
    assert_select 'form[action=?]', shift_submissions_path(@branch)
    assert_select 'select[name=period]'
    @branch.periods_before_deadline.each do |period|
      assert_select 'option[value=?]', period.id.to_s
      period.days.each { |date| assert_select 'option[value=?]', date.to_s }
    end
    forms_num(@branch)[:max].times do |n|
      assert_select 'select[name=?]', "shift_request[#{n}][date]"
      assert_select 'input[type=time][name=?]', "shift_request[#{n}][start_time]"
      assert_select 'input[type=time][name=?]', "shift_request[#{n}][end_time]"
    end
    assert_select 'input[type=submit]'
  end
  
  # ログイン捨ていなければリダイレクト
  test "should redirect new_shift when not login" do 
    logout
    get new_shift_submission_path(@branch)
    assert_response :redirect
  end
  
  # ログインユーザーがrelationship_idのユーザーではなかったらホームにリダイレクト
  test "should redirect new_shift when not correct_user" do
    branch_not_correct_user = branches(:branch_have_no_relationship)
    get new_shift_submission_path(branch_not_correct_user)
    assert_redirected_to root_url
  end
  
  # 正しい値を送信
  test "post create_shift with valid_params" do 
    assert_difference -> { ShiftSubmission.count } => 1, -> { ShiftRequest.count } => 5 do
      post shift_submissions_path(@branch), params: @valid_shift_submission_params
    end
  end
end
