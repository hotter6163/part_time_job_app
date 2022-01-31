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
    @period = Period.find_by(id: params[:period])
    unless @period && @period.before_deadline? && @period.branch == @branch
      @periods = []
      @days = {}
      @branch.periods_before_deadline.each do |period|
        @periods << [period.start_to_end, period.id]
        @days[period.id] = period.days
      end
      render 'shift_submissions/new_shift' and return
    end
    
    @shift_submission = @period.shift_submissions.build(user: current_user)
    @error_nums = []
    @shift_requests = {}
    params[:shift_request].each do |key, shift_request|
      # 送信された値の検証
      if shift_request.values.all?(&:blank?)
        next
      elsif !shift_request.values.all?(&:present?)
        @error_nums << key
        next
      end
      
      # モデルの検証
      @shift_requests[key] = @shift_submission.shift_requests.build(shift_request_params(shift_request))
      unless @shift_requests[key].valid?
        @error_nums << key
        next
      end
      
      unless @period.is_date_in?(@shift_requests[key].date)
        @error_nums << key
        next
      end
    end
    byebug
  end
  
  private
    def belong_to
      @branch = Branch.find_by(id: params[:id])
      unless @branch&.belong_to?(current_user)
        redirect_to root_url
      end
    end
    
    def shift_request_params(shift_request)
      result = shift_request.permit(:date)
      result[:start_time] = "#{shift_request['date']} #{shift_request['start_time']}"
      result[:end_time] = "#{shift_request['date']} #{shift_request['end_time']}"
      result
    end
end
