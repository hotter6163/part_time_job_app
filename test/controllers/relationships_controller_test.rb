require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_have_no_relationship)
    @branch = branches(:branch_have_no_relationship)
    login_as(@user) 
  end
  
  # params[:token]なしでget new
  test "get new wihtout params[:token]" do
    get new_relationship_path
    assert_redirected_to root_url
  end
end
