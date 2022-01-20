require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_have_no_relationship)
    @branch = branches(:branch_have_no_relationship)
  end
  
  # branch_idが不適切ならリダイレクト
  # get new
  test "should redirect new when invalid brnach_id" do 
    sign_in(@user)
    get new_relationship_path(branch_id: invalid_id)
    assert_redirected_to root_url
  end
  
  # ログインしていなければリダイレクト
  # post create
  test "should redirect create when not log in" do
    assert_no_difference "Relationship.count" do
      post relationships_path, params: { branch_id: @branch.id }
    end
    assert_redirected_to user_session_path
  end
  
  # branch_idが不適切ならリダイレクト
  # post create
  test "should not make new relationship when invalid branch_id" do 
    sign_in(@user)
    assert_no_difference "Relationship.count" do
      post relationships_path, params: { branch_id: invalid_id }
    end
    assert_not flash[:success]
    assert_not flash[:info]
    assert !!flash[:denger]
  end
  
  # 既に存在しているユーザーと企業の組み合わせでは登録されない
  test "should not make new relationship when relationship already exist" do
    user = users(:user)
    branch = branches(:branch)
    sign_in(user)
    assert_no_difference "Relationship.count" do
      post relationships_path, params: { branch_id: branch.id }
    end
    assert_not flash[:success]
    assert_not flash[:denger]
    assert !!flash[:info]
  end
  
  # 従業員の登録
  test "post create when sign in and send valid branch_id and not master" do
    sign_in(@user)
    assert_difference "Relationship.count", 1 do
      post relationships_path, params: { branch_id: @branch.id }
    end
    assert_redirected_to root_url
    assert !!flash[:success]
    assert_not flash[:denger]
    assert_not flash[:info]
    relationship = assigns(:relationship)
    assert_not relationship.master
    assert_not relationship.admin
  end
end
