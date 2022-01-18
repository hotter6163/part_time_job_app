require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_have_no_relationship)
    @branch = branches(:branch_have_no_relationship)
  end
  
  test "should redirect create when not log in" do
    assert_no_difference "Relationship.count" do
      post relationships_path, params: { branch_id: @branch.id }
    end
    assert_redirected_to user_session_path
  end
  
  test "should not make new relationship when invalid branch_id" do 
    sign_in(@user)
    assert_no_difference "Relationship.count" do
      post relationships_path, params: { branch_id: invalid_id }
    end
  end
  
  # 既に存在しているユーザーと企業の組み合わせでは登録されない
  test "should not make new relationship when relationship already exist" do
    sign_in(@user)
    post relationships_path, params: { branch_id: @branch.id }
    assert_no_difference "Relationship.count" do
      post relationships_path, params: { branch_id: @branch.id }
    end
  end
    
  
  # マスターユーザーの登録
  test "post create when sign in and send valid branch_id and master" do
    sign_in(@user)
    assert_difference "Relationship.count", 1 do
      post relationships_path, params: { branch_id: @branch.id, master: 1 }
    end
    assert_equal 204, response.status
    relationship = assigns(:relationship)
    assert relationship.master
    assert relationship.admin
  end
  
  # 従業員の登録
  test "post create when sign in and send valid branch_id and not master" do
    sign_in(@user)
    assert_difference "Relationship.count", 1 do
      post relationships_path, params: { branch_id: @branch.id }
    end
    assert_equal 204, response.status
    relationship = assigns(:relationship)
    assert_not relationship.master
    assert_not relationship.admin
  end
end
