require "test_helper"

class BranchTest < ActiveSupport::TestCase
  def setup 
    @company = companies(:company_have_no_branch)
    @branch = @company.branches.build(
      name: 'sample',
      display_day: 1,
      start_of_business_hours: '09:00',
      end_of_business_hours: '21:00',
      period_type: 0
      )
  end

  # バリデーションのテスト
  test "should be valid" do
    assert @branch.valid?
  end
  
  # nameが空白でないか
  test "name should be present" do
    @branch.name = "     "
    assert_not @branch.valid?
  end
  
  # nameが長すぎないか
  test "name should not be too long" do
    @branch.name = 'a' * 138
    assert_not @branch.valid?
  end
  
  # 別の会社の同じ支社名を登録できる
  test "should be valid when another company and same branch" do
    another_company = companies(:company1)
    another_branch = another_company.branches.build(name: @branch.name)
    another_branch.save
    assert @branch.valid?
  end
  
  # 同じ会社の別の支社名を登録できる
  test "should be valid when same company and another branch" do
    another_branch = @company.branches.build(name: "another")
    another_branch.save
    assert @branch.valid?
  end
  
  # 同じ会社の同じ支社名を登録できない
  test "should not be valid when same company and same branch" do
    another_branch = @branch.dup
    another_branch.save
    assert_not @branch.valid?
  end
  
  # companyモデルが削除されたとき、支店も削除される
  test "should destroy branch when company destroy" do
    @branch.save
    assert_difference 'Branch.count', -1 do
      @company.destroy
    end
  end
  
  test "should destroy has_one or has_many models when branch destroy" do
    weekly = @branch.build_weekly(start_day: 1, deadline_day: 7, num_of_weeks: 2)
    monthly = @branch.build_monthly(period_num: 1)
    period = @branch.periods.build(deadline: '2022-01-02', start_date: '2022-01-10', end_date: '2022-01-10')
    assert_difference ['Weekly.count', 'Monthly.count'], 1 do
      @branch.save
    end
    assert weekly.persisted?
    assert monthly.persisted?
    period.save
    assert_difference ['Weekly.count', 'Monthly.count', 'Period.count'], -1 do
      @branch.destroy
    end
  end
  
  # ----------------------------------------------
  # メソッドのテスト
  test "company_name" do
    assert_equal "#{@company.name} #{@branch.name}", @branch.company_name
  end
end
