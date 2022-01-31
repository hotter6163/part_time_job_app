require "test_helper"

class CompanyRegistrationTest < ActionDispatch::IntegrationTest
  def setup
    @company = companies(:company)
    @company_registration_params = 
        { company: {  name: 'new_company' },
          branch: { name: 'new_brnach',
                    start_of_business_hours: '08:30',
                    end_of_business_hours: '21:00',
                    period_type: 'two_weeks',
                    cross_day: '0'
                  },
          one_week: { start_day: 1,
                      deadline_day: 7
                    },
          two_weeks: {  start_day: 1,
                        start_date: '2022-02-07',
                        deadline_day: 7
                      },
          harf_month: { one: {  start_day: 1,
                                end_day: 15,
                                deadline_day: 20
                              },
                        two: {  start_day: 16,
                                end_day: 30,
                                deadline_day: 5
                              }
                      },
          one_month: {  start_day: 1,
                        end_day: 30,
                        deadline_day: 15
                      },
          user: 'new',
          start_date: "2022-02-07"
        }
    @new_user_params = {
      user: {
        first_name: "test",
        last_name: "test",
        email: "test@test.com",
        password: "password",
        password_confirmation: "password"
      }
    }
    @user = users(:user)
    @exist_user_params = { user: { email: @user.email, password: "password" } }
  end
  
  # 企業：新規
  # period_type: one_week
  # マスターユーザー：新規
  # 営業日が日をまたがない
  test "company: new, period_type: one_week, user: new" do
    get new_company_registration_path
    @company_registration_params[:company][:name] = 'new_company'
    @company_registration_params[:branch][:period_type] = 'one_week'
    @company_registration_params[:user] = 'new'
    start_date = '2022-01-31'
    @company_registration_params[:start_date] = start_date
    post check_company_registration_path, params: @company_registration_params
    get new_user_path
    
    # 不適切なユーザー情報を送信
    @new_user_params[:user][:first_name] = "    "
    assert_no_difference ['Company.count', 'Branch.count', 'Weekly.count', 'Monthly.count', 
                          'MonthlyPeriod.count', 'User.count', 'Relationship.count'] do
      post company_registrations_path, params: @new_user_params
    end
    assert !!session[:company_registration]
    assert !!session[:user]
    assert !!session[:start_date]
    assert_template 'company_registrations/new_user'
    
    # 正しい新規ユーザー情報を送信
    @new_user_params[:user][:first_name] = "test"
    assert_difference ->{ Company.count } => 1,
                      ->{ Branch.count } => 1,
                      ->{ Weekly.count } => 1,
                      ->{ Monthly.count } => 0,
                      ->{ MonthlyPeriod.count } => 0,
                      ->{ User.count } => 1,
                      ->{ Period.count } => 6,
                      ->{ Relationship.count } => 1 do
      post company_registrations_path, params: @new_user_params
    end
    relationship = Relationship.last
    assert relationship.master?
    assert relationship.admin?
    
    branch = assigns(:branch)
    assert_not branch.cross_day?
    periods = branch.periods.all
    assert_equal start_date.to_date, periods[0].start_date
    periods.each { |period| assert_equal @company_registration_params[:one_week][:start_day], period.start_date.wday }
    branch.subtype.reload
    assert_equal periods[-1].id, branch.subtype.period_id
    
    assert_nil session[:company_registration]
    assert_nil session[:user]
    assert_nil session[:start_date]
    assert_redirected_to branch_path(branch)
  end
  
  # 企業：既存
  # period_type: two_weeks
  # マスターユーザー：既存
  # 営業日が日をまたぐ
  test "company: exist, period_type: two_weeks, user: exist" do
    get new_company_registration_path
    @company_registration_params[:company][:name] = @company.name
    @company_registration_params[:branch][:period_type] = 'two_weeks'
    @company_registration_params[:user] = 'exist'
    start_date = '2022-02-07'
    @company_registration_params[:start_date] = start_date
    @company_registration_params[:branch][:cross_day] = '1'
    @company_registration_params[:branch][:end_of_business_hours] = '02:00'
    post check_company_registration_path, params: @company_registration_params
    get exist_user_path
    
    # 不適切なログイン情報を送信
    @exist_user_params[:user][:email] = "invalid_email@example.com"
    @exist_user_params[:user][:password] = "invalid-password"
    assert_no_difference ['Company.count', 'Branch.count', 'Weekly.count', 'Monthly.count', 
                          'MonthlyPeriod.count', 'User.count', 'Relationship.count'] do
      post company_registrations_path, params: @exist_user_params
    end
    assert !!session[:company_registration]
    assert !!session[:user]
    assert_template 'company_registrations/exist_user'
    
    # 適切なログイン情報を送信
    @exist_user_params[:user][:email] = @user.email
    @exist_user_params[:user][:password] = "password"
    assert_difference ->{ Company.count } => 0,
                      ->{ Branch.count } => 1,
                      ->{ Weekly.count } => 1,
                      ->{ Monthly.count } => 0,
                      ->{ MonthlyPeriod.count } => 0,
                      ->{ User.count } => 0,
                      ->{ Period.count } => 4,
                      ->{ Relationship.count } => 1 do
      post company_registrations_path, params: @exist_user_params
    end
    relationship = Relationship.last
    assert relationship.master?
    assert relationship.admin?
    
    branch = assigns(:branch)
    assert branch.cross_day?
    periods = branch.periods.all
    assert_equal start_date.to_date, periods[0].start_date
    periods.each { |period| assert_equal @company_registration_params[:one_week][:start_day], period.start_date.wday }
    branch.subtype.reload
    assert_equal periods[-1].id, branch.subtype.period_id
  end
  
  # 企業：新規
  # period_type: harf_month
  # マスターユーザー：新規
  test "company: new, period_type: harf_month, user: new" do
    get new_company_registration_path
    @company_registration_params[:company][:name] = 'new_company'
    @company_registration_params[:branch][:period_type] = 'harf_month'
    @company_registration_params[:user] = 'new'
    start_date = '2022-02-01'
    @company_registration_params[:start_date] = start_date
    post check_company_registration_path, params: @company_registration_params
    get new_user_path
    assert_difference ->{ Company.count } => 1,
                      ->{ Branch.count } => 1,
                      ->{ Weekly.count } => 0,
                      ->{ Monthly.count } => 1,
                      ->{ MonthlyPeriod.count } => 2,
                      ->{ User.count } => 1,
                      ->{ Period.count } => 4,
                      ->{ Relationship.count } => 1 do
      post company_registrations_path, params: @new_user_params
    end
    relationship = Relationship.last
    assert relationship.master?
    assert relationship.admin?
    
    branch = assigns(:branch)
    periods = branch.periods.all
    assert_equal start_date.to_date, periods[0].start_date
    
    # きれいな書き方わからんから力技のテスト
    assert_equal '2022-02-01'.to_date, periods[0].start_date
    assert_equal '2022-02-15'.to_date, periods[0].end_date
    assert_equal '2022-01-20'.to_date, periods[0].deadline
    assert_equal '2022-02-16'.to_date, periods[1].start_date
    assert_equal '2022-02-28'.to_date, periods[1].end_date
    assert_equal '2022-02-05'.to_date, periods[1].deadline
    assert_equal '2022-03-01'.to_date, periods[2].start_date
    assert_equal '2022-03-15'.to_date, periods[2].end_date
    assert_equal '2022-02-20'.to_date, periods[2].deadline
    assert_equal '2022-03-16'.to_date, periods[3].start_date
    assert_equal '2022-03-31'.to_date, periods[3].end_date
    assert_equal '2022-03-05'.to_date, periods[3].deadline
    
    
    branch.subtype.reload
    assert_equal periods[-1].id, branch.subtype.period_id
  end
  
  # 企業：既存
  # period_type: one_month
  # マスターユーザー：既存
  test "company: exist, period_type: one_month, user: exist" do
    get new_company_registration_path
    @company_registration_params[:company][:name] = @company.name
    @company_registration_params[:branch][:period_type] = 'one_month'
    @company_registration_params[:user] = 'exist'
    start_date = '2024-02-01'
    @company_registration_params[:start_date] = start_date
    post check_company_registration_path, params: @company_registration_params
    get exist_user_path
    assert_difference ->{ Company.count } => 0,
                      ->{ Branch.count } => 1,
                      ->{ Weekly.count } => 0,
                      ->{ Monthly.count } => 1,
                      ->{ MonthlyPeriod.count } => 1,
                      ->{ User.count } => 0,
                      ->{ Period.count } => 2,
                      ->{ Relationship.count } => 1 do
      post company_registrations_path, params: @exist_user_params
    end
    relationship = Relationship.last
    assert relationship.master?
    assert relationship.admin?
    
    branch = assigns(:branch)
    periods = branch.periods.all
    assert_equal start_date.to_date, periods[0].start_date
    
    # きれいな書き方わからんから力技のテスト
    assert_equal '2024-02-01'.to_date, periods[0].start_date
    assert_equal '2024-02-29'.to_date, periods[0].end_date
    assert_equal '2024-01-15'.to_date, periods[0].deadline
    assert_equal '2024-03-01'.to_date, periods[1].start_date
    assert_equal '2024-03-31'.to_date, periods[1].end_date
    assert_equal '2024-02-15'.to_date, periods[1].deadline
    
    branch.subtype.reload
    assert_equal periods[-1].id, branch.subtype.period_id
  end
end
