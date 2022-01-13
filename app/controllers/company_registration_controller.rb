class CompanyRegistrationController < ApplicationController
  def new
    @company = Company.new
  end
  
  def create
    @company = Company.find_by(company_params) || Company.new(company_params)
    unless company.valid?
      render 'company_registration/new' and return
    end
    session[:company_registration] = { company: company_params }
    @branch = Branch.new
    render 'company_registration/new_branch'
  end
  
    
  
  private
    def company_params
      params.require(:company).permit(:name)
    end
    
    def branch_params
      params.require(:branch).permit(:name)
    end
    
    def user_email
      params.require(:company).require(:master).permit(:email)
    end
end
