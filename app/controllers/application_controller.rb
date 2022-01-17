class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include BranchesHelper
  
  private
    # 新規登録時のストロングパラメータに「last_name, first_name」を追加
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name])
    end
    
    def have_name_in_session?(syn)
      !session[:company_registration].nil? && 
      !session[:company_registration][syn.to_s].nil? && 
      !session[:company_registration][syn.to_s]["name"].nil?
    end
    
    def registrate_company?
      have_name_in_session?(:company) && have_name_in_session?(:branch)
    end
    
    def company_registration
      company = Company.find_by(session[:company_registration]["company"]) || Company.create(session[:company_registration]["company"])
      branch = company.branches.create(session[:company_registration]["branch"])
      session[:company_registration] = nil
      Relationship.create(user: current_user, branch: branch, master: true, admin: true)
    end
end
