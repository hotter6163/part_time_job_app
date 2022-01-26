module ApplicationHelper
  include BranchesHelper
  include CompanyRegistrationsHelper
  include RelationshipsHelper
  include StaticPagesHelper
  
  def create_new_user(sign_up_params)
    build_resource(sign_up_params)

    resource.save
    resource
  end
end
