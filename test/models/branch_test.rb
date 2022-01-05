require "test_helper"

class BranchTest < ActiveSupport::TestCase
  def setup 
    @company = companies(:company_have_no_branch)
    @branch = @company.branches.build(name: 'sample')
  end
  
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
end
