require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_response :success
    assert_select 'a[href=?]', new_user_path
    assert_select 'a[href=?]', new_company_path
  end
end
