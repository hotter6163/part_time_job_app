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
    @company = Company.find_by(session[:company_registration]["company"]) || Company.new(session[:company_registration]["company"])
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
    if params[:user_select] == "new"
      
    elsif params[:user_select] == "existing"
      redirect_to input_user_email_path
    else
      render 'company_registration/input_user_email'
    end
  end
  
  def input_user_email
  end
  
  def search_user
    unless user = User.find_by(user_email)
      flash[:danger] = "入力されたEメールは登録されていません。"
      render "company_registration/input_user_email" and return
    end
    company = Company.find_by(session[:company_registration]["company"]) || Company.create(session[:company_registration]["company"])
    branch = company.branches.create(session[:company_registration]["branch"])
    session[:company_registration] = nil
    if user_signed_in?
      flash[:success] = "企業情報が登録されました。マイページから企業ページにアクセスしてください。"
      redirect_to root_url
    else
      flash[:success] = "企業情報が登録されました。マイページから企業ページにアクセスしてください。"
      redirect_to new_user_session_path
    end
  end
  
  private
    def company_params
      params.require(:company).permit(:name)
    end
    
    def branch_params
      params.require(:branch).permit(:name)
    end
    
    def user_email
      params.permit(:email)
    end
end
