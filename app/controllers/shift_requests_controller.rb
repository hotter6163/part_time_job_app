class ShiftRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :make_instance_variables
  before_action :before_deadline
  
  def create
  end
  
  def destroy
    @shift_request.destroy
    redirect_to shift_submission_path(@period)
  end
  
  private
    def make_instance_variables
      unless @shift_submission = current_user.shift_submissions.find_by(id: params[:shift_submission_id])
        redirect_to root_url and return
      end
      @period = @shift_submission.period
      unless @shift_request = @shift_submission.shift_requests.find_by(id: params[:id])
        redirect_to root_url and return
      end
    end
end
