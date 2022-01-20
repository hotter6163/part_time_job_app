class CompanyRegistrationController < ApplicationController
  before_action :have_company_name, except: [:input_company, :create_company]
  before_action :have_branch_name, except: [:input_company, :create_company, :input_branch, :create_branch]
  
  # get input_company
  # 企業情報の入力
  def input_company
    @company = Company.new
  end
  
  # post create_company
  # 企業情報の確認
  def create_company
    @company = Company.find_by(company_params) || Company.new(company_params)
    unless @company.valid?
      render 'company_registration/input_company' and return
    end
    session[:company_registration] = { company: company_params }
    redirect_to input_branch_path
  end
  
  # get input_branch
  # 支店情報の入力
  def input_branch
    @branch = Branch.new
  end
  
  # post create_branch
  # 支店情報の確認
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
  # マスターユーザーの選択
  def select_user
  end
  
  # post selecter
  # マスターユーザーの選択によってページを飛ばす
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
    # 企業情報のストロングパラメータ
    def company_params
      params.require(:company).permit(:name)
    end
    
    # 支店情報のストロングパラメータ
    def branch_params
      params.require(:branch).permit(:name)
    end
    
    # 企業情報を持っているかの確認
    def have_company_name
      redirect_to input_company_path unless have_name_in_session?(:company)
    end
    
    # 支店情報を持っているかの確認
    def have_branch_name
      redirect_to input_branch_path unless have_name_in_session?(:branch)
    end
end
