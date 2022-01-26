class CompanyRegistrationsController < ApplicationController
  def new
    @company = Company.new
    @branch = @company.branches.build
    @weekly = @branch.build_weekly
    @monthly = @branch.build_monthly
    @monthly_period = @monthly.monthly_periods.build
  end
  
  def create
    byebug
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
