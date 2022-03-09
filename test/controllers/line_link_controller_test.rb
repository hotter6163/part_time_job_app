require "test_helper"

class LineLinkControllerTest < ActionDispatch::IntegrationTest
  test "should get sign_up" do
    get line_link_sign_up_url
    assert_response :success
  end

  test "should get sign_in" do
    get line_link_sign_in_url
    assert_response :success
  end
end
