require "test_helper"

class CompanyRegistrationTest < ActionDispatch::IntegrationTest
  test "company_registration" do
    get new_company_registration
    company_name = "company"
    post company_registration_index, params: { company: { name: company_name } }
  end
end
