class ShiftSubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to
  
  def new_shift
    @periods = []
    @days = {}
    @branch.periods_before_deadline.each do |period|
      @periods << [period.start_to_end, period.id]
      @days[period.id] = period.days
    end
    
  end
  
  def create_shift
  end
  
  private
    def belong_to
      @branch = Branch.find_by(id: params[:id])
      unless @branch&.belong_to?(current_user)
        redirect_to root_url
      end
    end
end
