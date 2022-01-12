class CompanyRegistrationController < ApplicationController
  def new
    @company = Company.new
    @branch = Branch.new
  end
  
  def create
    @company = Company.find_by(company_params) || Company.create(company_params)
    @branch = @company.branches.build(branch_params)
    
  end
  
  private
    def company_params
      params.require(:company).permit(:name)
    end
    
    def branch_params
      params.require(:company).require(:branch).permit(:name)
    end
end
