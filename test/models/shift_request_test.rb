require "test_helper"

class ShiftRequestTest < ActiveSupport::TestCase
  def setup
    @ss = shift_submissions(:one)
    @sq = @ss.shift_requests.build(
      date: "2022-02-01",
      start_time: "2022-02-01 14:00",
      end_time: "2022-02-02 02:00"
    )
  end
  
  test "should be valid" do
    assert @sq.valid?
  end
  
  test "date should be presence" do 
    @sq.date = nil
    assert_not @sq.valid?
  end
  
  test "start_time should be presence" do 
    @sq.start_time = nil
    assert_not @sq.valid?
  end
  
  test "end_time should be presence" do 
    @sq.end_time = nil
    assert_not @sq.valid?
  end
  
  test "start_time should be less than end_time" do
    @sq.end_time = "2022-02-01 02:00"
    @sq.valid?
  end
end
