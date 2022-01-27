require "test_helper"

class CompanyRegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @company_name = "test_company"
    @branch_name = "test_branch"
    @company_registration_params = 
        { company: {  name: 'new_company' },
          branch: { name: 'new_brnach',
                    start_of_business_hours: '08:30',
                    end_of_business_hours: '21:00',
                    period_type: 'two_weeks'
                  },
          one_week: { start_day: 1,
                      start_date: '2022-01-31',
                      deadline: 7
                    },
          two_weeks: {  start_day: 1,
                        start_date: '2022-02-07',
                        deadline: 7
                      },
          harf_month: { one: {  start_day: 1,
                                end_day: 15,
                                deadline: 20
                              },
                        twe: {  start_day: 16,
                                end_day: 30,
                                deadline: 5
                              }
                      },
          one_month: {  start_day: 1,
                        end_day: 30,
                        deadline_day: 15
                      },
          user: { user_select: 'new'}
        }
  end
  
  test "should get new" do 
    get new_company_registration_path
    assert_response :success
    # 共通フォーム
    assert_select 'form[action=?]', company_registrations_path
    
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
    
    # シフト期間情報
    # 1週間
    assert_select 'select[name=?]', 'one_week[start_day]'
    assert_select 'input[type=date][name=?]', 'one_week[start_date]'
    assert_select 'input[type=number][name=?]', 'one_week[deadline]'
    
    # 2週間
    assert_select 'select[name=?]', 'two_weeks[start_day]'
    assert_select 'input[type=date][name=?]', 'two_weeks[start_date]'
    assert_select 'input[type=number][name=?]', 'two_weeks[deadline]'
    
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
    assert_select 'input[type=radio][name=?][value=?]', 'user[user_select]', 'new'
    assert_select 'input[type=radio][name=?][value=?]', 'user[user_select]', 'exist'
  end
  
  # createに正しい値が送信され、マスターが新規の時
  # test "post valid params and user_select is new" do 
  #   @company_registration_params[:user][:user_select] = "new"
  #   post company_registrations_path, params: @company_registration_params
  #   assert_redirected_to new_user_registration_path
  # end
  
  # createに正しい値が送信され、マスターが既存の時
  test "post valid params and user_select is exist" do
    
  end
  
end
