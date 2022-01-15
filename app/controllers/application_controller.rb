class ApplicationController < ActionController::Base
  require 'uri'
  require 'net/http'
  
  before_action :configure_permitted_parameters, if: :devise_controller?

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
      save_relationship(branch, master: true)
    end
    
    def save_relationship(branch_id, master: false)
      unless branch = Branch.find_by(id: branch_id)
        return
      end
      @relationship = new_relationship(branch, master)
      @relationship.save if @relationship.valid?
    end
    
    def new_relationship(branch, master)
      result = branch.relationships.build(user: current_user)
      if master && !Relationship.exist_master?(branch)
        result.master = true
        result.admin = true
      end
      result
    end
end
