require "test_helper"

class MonthlyTest < ActiveSupport::TestCase
  def setup
    @company = companies(:company_have_no_branch)
    @branch = @company.branches.build(
      name: 'sample',
      display_day: 1,
      start_of_business_hours: '09:00',
      end_of_business_hours: '21:00',
      period_type: 0
      )
    @monthly = @branch.build_monthly(period_num: 1)
    @monthly_period = @monthly.monthly_periods.build(start_day: 1, end_day: 30, deadline_day: 15)
  end
  
  test 'monthly and monthly_period should be valid' do 
    assert @monthly.valid?
    assert @monthly_period.valid?
  end
  
  # Monthlyのperiod_numは1か2
  test "monthly_period_num should be 1 or 2" do
    (-2..3).to_a.each do |i|
      @monthly.period_num = i
      if (1..2).to_a.include?(i)
        assert @monthly.valid?
      else
        assert_not @monthly.valid?
      end
    end
  end
  
  # MonthlyPeriodのdayの値は1から30
  test "day in MonthlyPeriod should be in 1..30" do
    [:start, :end, :deadline].each do |syn|
      (-5..35).to_a.each do |i|
        @monthly_period.send("#{syn}_day=", i)
        if (1..30).to_a.include?(i)
          assert @monthly_period.valid?
        else
          assert_not @monthly_period.valid?
        end
      end
      @monthly_period.send("#{syn}_day=", 1)
    end
  end
end
