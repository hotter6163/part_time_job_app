require "test_helper"

class PeriodTest < ActiveSupport::TestCase
  def setup
    @branch = branches(:branch)
    @period = Period.new( branch: @branch, 
                          deadline: '2022-01-02',
                          start_date: '2022-01-10', 
                          end_date: '2022-01-10')
  end
  
  # 
  test "deadline uniqueness scope branch_id" do
    # 同じ支店の別の締め切り日
    period_same_branch_and_other_deadline = @period.dup
    period_same_branch_and_other_deadline.deadline = '2022-01-01'
    period_same_branch_and_other_deadline.save
    # assert @period.valid?
  end
end
