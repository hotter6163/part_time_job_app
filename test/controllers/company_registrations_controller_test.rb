require "test_helper"

class CompanyRegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @start_date = '2022-08-01'
    @company_registration_params = 
        { company: {  name: 'new_company' },
          branch: { name: 'new_brnach',
                    start_of_business_hours: '08:30',
                    end_of_business_hours: '21:00',
                    period_type: 'two_weeks'
                  },
          one_week: { start_day: 1,
                      deadline_day: 7
                    },
          two_weeks: {  start_day: 1,
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
          start_date: @start_date
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
    user = users(:user)
    @exist_user_params = { user: { email: user.email, password: "password" } }
  end
  
  # ------------------------------------------------
  # get new
  test "should get new" do 
    get new_company_registration_path
    assert_response :success
    # 共通フォーム
    assert_select 'form[action=?]', check_company_registration_path
    
    # 企業情報
    assert_select 'input[name=?]', 'company[name]'
    
    # 店舗情報
    assert_select 'input[name=?]', 'branch[name]'
    assert_select 'input[type=time][name=?]', 'branch[start_of_business_hours]'
    assert_select 'input[type=time][name=?]', 'branch[end_of_business_hours]'
    assert_select 'input[type=radio][name=?][value=?]', 'branch[period_type]', 'one_week'
    assert_select 'input[type=radio][name=?][value=?]', 'branch[period_type]', 'two_weeks'
    assert_select 'input[type=radio][name=?][value=?]', 'branch[period_type]', 'harf_month'
    assert_select 'input[type=radio][name=?][value=?]', 'branch[period_type]', 'one_month'
    
    # シフト開始日情報
    assert_select 'input[type=date][name=?]', 'start_date'
    
    # シフト期間情報
    # 1週間
    assert_select 'select[name=?]', 'one_week[start_day]'
    assert_select 'input[type=number][name=?]', 'one_week[deadline_day]'
    
    # 2週間
    assert_select 'select[name=?]', 'two_weeks[start_day]'
    assert_select 'input[type=number][name=?]', 'two_weeks[deadline_day]'
    
    # 半月
    assert_select 'select[name=?]', 'harf_month[one][start_day]'
    assert_select 'select[name=?]', 'harf_month[one][end_day]'
    assert_select 'select[name=?]', 'harf_month[one][deadline_day]'
    assert_select 'select[name=?]', 'harf_month[two][start_day]'
    assert_select 'select[name=?]', 'harf_month[two][end_day]'
    assert_select 'select[name=?]', 'harf_month[two][deadline_day]'
    
    # 1ヵ月
    assert_select 'select[name=?]', 'one_month[start_day]'
    assert_select 'select[name=?]', 'one_month[end_day]'
    assert_select 'select[name=?]', 'one_month[deadline_day]'
    
    # マスターユーザー
    assert_select 'input[type=radio][name=?][value=?]', 'user', 'new'
    assert_select 'input[type=radio][name=?][value=?]', 'user', 'exist'
  end
  
  # ------------------------------------------------
  # post check_company
  # check_companyに正しい値が送信され、マスターが新規の時
  test "post check_company with valid params and user_select is new" do 
    @company_registration_params[:user] = "new"
    post check_company_registration_path, params: @company_registration_params
    assert_equal :new, session[:user]
    assert_equal @start_date, session[:start_date]
    assert_redirected_to new_user_path
  end
  
  # check_companyに正しい値が送信され、マスターが既存の時
  test "post check_company with valid params and user_select is exist" do
    @company_registration_params[:user] = "exist"
    post check_company_registration_path, params: @company_registration_params
    assert_equal :exist, session[:user]
    assert_equal @start_date, session[:start_date]
    assert_redirected_to exist_user_path
  end
  
  # check_companyに正しい値が送信され、マスターがnew、exist以外の時
  test "post check_company with valid params and user_select is invalid" do
    @company_registration_params[:user] = "wrong"
    post check_company_registration_path, params: @company_registration_params
    assert_template "company_registrations/new"
    assert_nil session[:user]
  end
  
  # POST check_company, period_type="one_week"
  test 'post check_company with period_type="one_week"' do
    @company_registration_params[:branch][:period_type] = 'one_week'
    @company_registration_params[:start_date] = 
    post check_company_registration_path, params: @company_registration_params
    assert !!session[:company_registration][:company]
    assert !!session[:company_registration][:branch]
    assert !!session[:company_registration][:weekly]
    assert_not !!session[:company_registration][:monthly]
    assert_equal 1, session[:company_registration][:weekly][:num_of_weeks]
    weekly = assigns(:weekly)
    monthly = assigns(:monthly)
    assert !!weekly
    assert_nil monthly
  end
  
  # POST check_company, period_type="two_weeks"
  test 'post check_company with period_type="two_weeks"' do
    @company_registration_params[:branch][:period_type] = 'two_weeks'
    post check_company_registration_path, params: @company_registration_params
    assert !!session[:company_registration][:company]
    assert !!session[:company_registration][:branch]
    assert !!session[:company_registration][:weekly]
    assert_not !!session[:company_registration][:monthly]
    assert_equal 2, session[:company_registration][:weekly][:num_of_weeks] 
    weekly = assigns(:weekly)
    monthly = assigns(:monthly)
    assert !!weekly
    assert_nil monthly
  end
  
  # POST check_company, period_type="harf_month"
  test 'post check_company with period_type="harf_month"' do
    @company_registration_params[:branch][:period_type] = 'harf_month'
    post check_company_registration_path, params: @company_registration_params
    assert !!session[:company_registration][:company]
    assert !!session[:company_registration][:branch]
    assert_not !!session[:company_registration][:weekly]
    assert !!session[:company_registration][:monthly]
    assert_equal 2, session[:company_registration][:monthly][:period_num]
    assert_equal 2, session[:company_registration][:monthly_periods].count
    weekly = assigns(:weekly)
    monthly = assigns(:monthly)
    assert !!monthly
    assert_nil weekly
  end
  
  # POST check_company, period_type="one_month"
  test 'post check_company with period_type="one_month"' do
    @company_registration_params[:branch][:period_type] = 'one_month'
    post check_company_registration_path, params: @company_registration_params
    assert !!session[:company_registration][:company]
    assert !!session[:company_registration][:branch]
    assert_not !!session[:company_registration][:weekly]
    assert !!session[:company_registration][:monthly]
    assert_equal 1, session[:company_registration][:monthly][:period_num]
    assert_equal 1, session[:company_registration][:monthly_periods].count
    weekly = assigns(:weekly)
    monthly = assigns(:monthly)
    assert !!monthly
    assert_nil weekly
  end
  
  # before_action :have_company_registration_sessionのテスト
  # get new_user
  test "should redirect new_user when not session[:company_registration]" do
    get new_user_path
    assert_redirected_to new_company_registration_path
  end
  
  # before_action :have_company_registration_sessionのテスト
  # get exist_user
  test "should redirect exist_user when not session[:company_registration]" do
    get exist_user_path
    assert_redirected_to new_company_registration_path
  end
  
  # before_action :new_user_filterのテスト
  # get new_user
  test "should redirect new_user when session[:user] is not 'new'" do
    @company_registration_params[:user] = "exist"
    post check_company_registration_path, params: @company_registration_params
    get new_user_path
    assert_redirected_to new_company_registration_path
  end
  
  # before_action :exist_user_filterのテスト
  # get exist_user
  test "should redirect new_user when session[:user] is not 'exist'" do
    @company_registration_params[:user] = "new"
    post check_company_registration_path, params: @company_registration_params
    get exist_user_path
    assert_redirected_to new_company_registration_path
  end
  
  # get new_user 
  test "get new_user when have session[:company_registration]" do 
    @company_registration_params[:user] = "new"
    post check_company_registration_path, params: @company_registration_params
    get new_user_path
    assert_response :success
    assert_template 'company_registrations/new_user'
    assert_select 'form[action=?]', company_registrations_path
    assert_select 'input[type=text][name=?]', 'user[last_name]'
    assert_select 'input[type=text][name=?]', 'user[first_name]'
    assert_select 'input[type=email][name=?]', 'user[email]'
    assert_select 'input[type=password][name=?]', 'user[password]'
    assert_select 'input[type=password][name=?]', 'user[password_confirmation]'
    assert_select 'input[type="submit"][name="commit"]'
  end
  
  # get exist_user
  test "get exist_user when have session[:company_registration]" do 
    @company_registration_params[:user] = "exist"
    post check_company_registration_path, params: @company_registration_params
    get exist_user_path
    assert_response :success
    assert_template 'company_registrations/exist_user'
    assert_select 'form[action=?]', company_registrations_path
    assert_select 'input[type=email][name=?]', 'user[email]'
    assert_select 'input[type=password][name=?]', 'user[password]'
    assert_select 'input[type="submit"][name="commit"]'
  end
end
