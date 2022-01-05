require "test_helper"

class BrunchTest < ActiveSupport::TestCase
  def setup 
    @company = companies(:company_have_no_brunch)
    @brunch = @company.brunches.build(name: 'sample')
  end
  
  test "should be valid" do
    assert @brunch.valid?
  end
  
  # nameが空白でないか
  test "name should be present" do
    @brunch.name = "     "
    assert_not @brunch.valid?
  end
  
  # nameが長すぎないか
  test "name should not be too long" do
    @brunch.name = 'a' * 138
    assert_not @brunch.valid?
  end
  
  # 別の会社の同じ支社名を登録できる
  test "should be valid when another company and same brunch" do
    another_company = companies(:company1)
    another_brunch = another_company.brunches.build(name: @brunch.name)
    another_brunch.save
    assert @brunch.valid?
  end
  
  # 同じ会社の別の支社名を登録できる
  test "should be valid when same company and another brunch" do
    another_brunch = @company.brunches.build(name: "another")
    another_brunch.save
    assert @brunch.valid?
  end
  
  # 同じ会社の同じ支社名を登録できない
  test "should not be valid when same company and same brunch" do
    another_brunch = @brunch.dup
    another_brunch.save
    assert_not @brunch.valid?
  end
  
  # companyモデルが削除されたとき、支店も削除される
  test "should destroy brunch when company destroy" do
    @brunch.save
    assert_difference 'Brunch.count', -1 do
      @company.destroy
    end
  end
end
