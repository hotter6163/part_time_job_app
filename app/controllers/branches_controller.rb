class BranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user
  
  def show
  end
  
  def add_employee
  end
  
  def send_email
    
  end
  
  private
    def admin_user
      @branch = Branch.find_by(id: params[:id])
      unless admin_user?(user: current_user, branch: @branch)
        redirect_to(root_url)
      end
    end
end
