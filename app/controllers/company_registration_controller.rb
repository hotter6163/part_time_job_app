class CompanyRegistrationController < ApplicationController
  before_action :have_company_name, only: [:input_branch, :create_branch, :select_user, :selecter]
  before_action :have_branch_name, only: [:select_user, :selecter]
  
  # get input_company
  def input_company
    @company = Company.new
  end
  
  # post create_company
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
  
  # post create_branch
  def create_branch
    @company = Company.find_by(session[:company_registration]["company"]) || Company.new(session[:company_registration]["company"])
    @branch = @company.branches.build(branch_params)
    unless @branch.valid?
      render 'company_registration/input_branch' and return
    end
    session[:company_registration][:branch] = branch_params
    redirect_to select_user_path
  end
  
  # get select_user
  def select_user
  end
  
  # post selecter
  def selecter
    if params[:user_select] == "new"
      redirect_to new_user_registration_path
    elsif params[:user_select] == "existing"
      redirect_to new_user_session_path
    else
      render 'company_registration/select_user'
    end
  end
  
  private
    def company_params
      params.require(:company).permit(:name)
    end
    
    def branch_params
      params.require(:branch).permit(:name)
    end
    
    def have_company_name
      redirect_to input_company_path unless have_name_in_session?(:company)
    end
    
    def have_branch_name
      redirect_to input_branch_path unless have_name_in_session?(:branch)
    end
end
