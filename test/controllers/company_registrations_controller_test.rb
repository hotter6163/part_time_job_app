require "test_helper"

class CompanyRegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @company_name = "test_company"
    @branch_name = "test_branch"
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
  end
end
