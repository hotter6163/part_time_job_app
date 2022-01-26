require "test_helper"

class WeeklyTest < ActiveSupport::TestCase
  def setup
    @company = companies(:company_have_no_branch)
    @branch = @company.branches.build(
      name: 'sample',
      display_day: 1,
      start_of_business_hours: '09:00',
      end_of_business_hours: '21:00',
      period_type: 0
      )
    @weekly = @branch.build_weekly( start_day: 1, 
                                    deadline_day: 8,
                                    num_of_weeks: 2
                                  )
  end
  
  test "should be valid" do 
    assert @weekly.valid?
  end
  
  # start_dayは0～6(曜日を表現)
  test "start_day should be between 0 to 6" do
    (-3..8).each do |n|
      @weekly.start_day = n
      if (0..6).to_a.include?(n)
        assert @weekly.valid?
      else
        assert_not @weekly.valid?
      end
    end
  end
end
