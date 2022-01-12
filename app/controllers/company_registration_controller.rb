class CompanyRegistrationController < ApplicationController
  def new
    @company = Company.new
    @branch = Branch.new
  end
  
  def create
    @company = Company.find_by(company_params) || Company.new(company_params)
    @branch = @company.branches.build(branch_params)
    @user = User.find_by(user_email)
    if @user && @company.valud? && @branch.valid?
      
    else
      render 'company_registration/new'
    end
  end
  
  private
    def company_params
      params.require(:company).permit(:name)
    end
    
    def branch_params
      params.require(:company).require(:branch).permit(:name)
    end
    
    def user_email
      params.require(:company).require(:master).permit(:email)
    end
end
