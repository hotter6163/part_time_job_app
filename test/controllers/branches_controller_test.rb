require "test_helper"

class BranchesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    branch = Branch.first
    get branch_path(branch)
    assert_response :success
  end
end
