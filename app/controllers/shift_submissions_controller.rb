class ShiftSubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to
  before_action :before_deadline, only: [:new_shift, :create_shift]
  before_action :already_submit_shift, only: [:new_shift, :create_shift]
  before_action :not_submit_shift, only: [:show]
  
  def new_shift
    @error_nums = Set.new
  end
  
  def create_shift
    @shift_submission = @period.shift_submissions.build(user: current_user)
    @error_nums = Set.new
    
    verify_params
    
    if @error_nums.empty?
      @shift_submission.save
      render "shift_submissions/success"
    else
      flash.now[:danger] = "登録できない項目があります。"
      render "shift_submissions/new_shift"
    end
  end
  
  def show
  end
  
  private
    def belong_to
      unless @period = Period.find_by(id: params[:id])
        redirect_to root_url
      end
      @branch = @period.branch
      unless @branch&.belong_to?(current_user)
        redirect_to root_url
      end
    end
    
    def before_deadline
      unless @period.before_deadline?
        redirect_to root_url
      end
    end
    
    def already_submit_shift
      if !!@period.shift_submissions.find_by(user: current_user)
        redirect_to shift_submission_path(@period)
      end
    end
    
    def not_submit_shift
      @shift_submission = @period.shift_submissions.find_by(user: current_user)
      unless !!@shift_submission
        redirect_to new_shift_submission_path(@period)
      end
    end
    
    def shift_request_params(shift_request)
      return unless shift_request.values.all?(&:present?)
      result = shift_request.permit(:date)
      result[:start_time] = @branch.time_in_business_hours(shift_request['date'].to_date, shift_request['start_time'].in_time_zone)
      result[:end_time] = @branch.time_in_business_hours(shift_request['date'].to_date, shift_request['end_time'].in_time_zone)
      result[:end_time] + 1.day if result[:start_time] > result[:end_time]
      result
    end
    
    def valid?(shift_request)
      # モデルのバリデーション
      # 提出したシフトの範囲内か
      return false unless shift_request.valid? && @period.is_date_in?(shift_request.date)
      
      # 同じ日付が複数ないか
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
    
    def verify_params
      @shift_requests = {}
      
      params[:shift_request].each do |key, value|
        # 送信された値の検証
        next if value.values.all?(&:blank?)
        
        shift_request = @shift_submission.shift_requests.build(shift_request_params(value))
        unless valid?(shift_request)
          @error_nums << key
          next
        end
        
        @shift_requests[key] = shift_request
      end
    end
end
