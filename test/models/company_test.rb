require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  def setup
    @company = Company.new(name: 'sample company')
  end
  
  test "should be valid" do
    assert @company.valid?
  end
  
  # nameが空白でないか
  test "name should be present" do
    @company.name = "     "
    assert_not @company.valid?
  end
  
  # nameが長すぎないか
  test "name should not be too long" do
    @company.name = 'a' * 138
    assert_not @company.valid?
  end
end
