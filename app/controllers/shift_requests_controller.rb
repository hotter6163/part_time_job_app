class ShiftRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_shift_submission
  before_action :find_shift_request, only: [:destroy]
  before_action :before_deadline
  
  def create
    unless params[:shift_request].values.all?(&:present?) && @period.is_date_in?(params[:shift_request]["date"].to_date)
      flash.now[:danger] = "送信されたシフトが追加・変更できませんでした。"
      redirect_to shift_submission_path(@period) and return
    end
    
    @branch = @period.branch
    shift_request =  @shift_submission.shift_requests.find_by(date: shift_request_params(params[:shift_request])[:date]) ||
                      @shift_submission.shift_requests.build(date: shift_request_params(params[:shift_request])[:date])
    shift_request.start_time = shift_request_params(params[:shift_request])[:start_time]
    shift_request.end_time = shift_request_params(params[:shift_request])[:end_time]
    if shift_request.valid?
      shift_request.save
      flash.now[:success] = "#{date_display(shift_request.date)}のシフトを追加・変更しました。"
    else
      flash.now[:danger] = "送信されたシフトが追加・変更できませんでした。"
    end
    redirect_to shift_submission_path(@period)
  end
  
  def destroy
    @shift_request.destroy
    redirect_to shift_submission_path(@period)
  end
  
  private
    def find_shift_submission
      if @shift_submission = current_user.shift_submissions.find_by(id: params[:shift_submission_id])
        @period = @shift_submission.period
      else
        redirect_to root_url
      end
    end
    
    def find_shift_request
      unless @shift_request = @shift_submission.shift_requests.find_by(id: params[:id])
        redirect_to root_url
      end
    end
end
