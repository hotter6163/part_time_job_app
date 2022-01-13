class CompanyRegistrationController < ApplicationController
  # get input_company
  def input_company
    @company = Company.new
  end
  
  # post input_company
  def create_company
    @company = Company.find_by(company_params) || Company.new(company_params)
    unless @company.valid?
      render 'company_registration/input_company' and return
    end
    session[:company_registration] = { company: company_params }
    redirect_to input_branch_path
  end
  
  # get input_branch
  def input_branch
    @branch = Branch.new
  end
  
  # post input_branch
  def create_branch
    @company = Company.find_by(session[:company_registration][:company]) || Company.new(session[:company_registration][:company])
    @branch = @company.branches.build(branch_params)
    unless @branch.valid?
      render 'company_registration/input_branch' and return
    end
    session[:company_registration][:branch] = branch_params
    redirect_to select_user_path
  end
  
  def select_user
  end
  
  def selecter
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
