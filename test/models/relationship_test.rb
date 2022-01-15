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
  
  # ユーザーidとブランチidの組み合わせの一意性
  test "should not valid when same user_id adn branch_id" do
    another_relationship = @relationship.dup
    another_relationship.save
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
  
  test "Relationship.exist_master?" do
    branch = branches(:branch_have_no_relationship)
    assert_not Relationship.exist_master?(branch)
    user = users(:user_have_no_relationship)
    branch.relationships.create(user: user, master: 1, admin: 1)
    assert Relationship.exist_master?(branch)
  end
end