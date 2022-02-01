class ShiftSubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to
  
  def new_shift
    before_render_new_shift
  end
  
  def create_shift
    @period = Period.find_by(id: params[:period])
    unless @period && @period.before_deadline? && @period.branch == @branch
      before_render_new_shift
      render 'shift_submissions/new_shift' and return
    end
    
    @shift_submission = @period.shift_submissions.build(user: current_user)
    @error_nums = Set.new
    @shift_requests = {}
    
    params[:shift_request].each do |key, value|
      # 送信された値の検証
      if value.values.all?(&:blank?)
        next
      end
      
      shift_request = @shift_submission.shift_requests.build(shift_request_params(value))
      unless valid?(shift_request)
        @error_nums << key
        next
      end
      
      @shift_requests[key] = shift_request
    end
    
    if @error_nums.empty?
      @shift_submission.save
      render "shift_submissions/success"
    else
      before_render_new_shift
      render "shift_submissions/new_shift"
    end
  end
  
  private
    def belong_to
      @branch = Branch.find_by(id: params[:id])
      unless @branch&.belong_to?(current_user)
        redirect_to root_url
      end
    end
    
    def shift_request_params(shift_request)
      return  unless shift_request.values.all?(&:present?)
      result = shift_request.permit(:date)
      result[:start_time] = @branch.time_in_business_hours(shift_request['date'].to_date, shift_request['start_time'].in_time_zone)
      result[:end_time] = @branch.time_in_business_hours(shift_request['date'].to_date, shift_request['end_time'].in_time_zone)
      result[:end_time] + 1.day if result[:start_time] > result[:end_time]
      result
    end
    
    def before_render_new_shift
      @periods = []
      @days = {}
      @branch.periods_before_deadline.each do |period|
        @periods << [period.start_to_end, period.id]
        @days[period.id] = period.days
      end
    end
    
    def valid?(shift_request)
      unless shift_request.valid?
        return false
      end
      unless @period.is_date_in?(shift_request.date)
        return false
      end
      flg = false
      @shift_requests.each do |key, value|
        if value.date.to_s == shift_request.date.to_s
          flg = true
          @error_nums << key 
        end
      end
      if flg
        return false
      end
      true
    end
end
