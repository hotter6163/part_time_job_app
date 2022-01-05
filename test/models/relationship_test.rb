require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_have_no_relationship)
    @branch = branches(:branch_have_no_relationship)
    @relationship = Relationship.new(user_id: @user.id, branch_id: @branch.id)
  end
  
  test "should be valid" do
    assert @relationship.valid?
  end
  
  # ユーザーidが空欄ではない
  test "user_id should be present" do
    @relationship.user_id = nil
    assert_not @relationship.valid?
  end
  
  # ブランチIDが空欄ではない
  test "branch_id should be present" do
    @relationship.branch_id = nil
    assert_not @relationship.valid?
  end
  
  # ユーザーが削除された時にrelationshipも削除される
  test "should destroy relationship when user destroy" do
    @relationship.save
    assert_difference "Relationship.count", -1 do
      @user.destroy
    end
  end
  
  # ブランチが削除された時にrelationshipも削除される
  test "should destroy relationship when branch destroy" do
    @relationship.save
    assert_difference "Relationship.count", -1 do
      @branch.destroy
    end
  end
end
