require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  def setup
    @company = Company.new(name: 'sample company')
  end
  
  # バリデーションのテスト
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
  
  # nameの一意性
  test "name should be uniqueness" do
    other_company = @company.dup
    other_company.save
    assert_not @company.valid?
  end
end
