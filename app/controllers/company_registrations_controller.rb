class CompanyRegistrationsController < ApplicationController
  before_action :have_company_registration_session, only: [:new_user, :exist_user, :create]
  before_action :new_user_filter, only: [:new_user]
  before_action :exist_user_filter, only: [:exist_user]
  
  def new
    @company = Company.new
    @branch = @company.branches.build
  end
  
  def check_company
    @error_messages = []
    unless valid_params?
      render "company_registrations/new" and return
    end
    
    @company = Company.find_by(company_params) || Company.new(company_params)
    @branch = @company.branches.build(branch_params)
    if !!session_params[:weekly]
      @weekly = @branch.build_weekly(session_params[:weekly])
      unless @weekly.valid? # 未テスト
        render "company_registrations/new" and return
      end
    elsif !!session_params[:monthly]
      @monthly = @branch.build_monthly(session_params[:monthly])
      @monthly_periods = session_params[:monthly_periods].map { |param| @monthly.monthly_periods.build(param) }
      unless @monthly_periods.all? { |monthly_period| monthly_period.valid? } # 未テスト
        render "company_registrations/new" and return
      end
    else # 未テスト
      render "company_registrations/new" and return
    end
    
    if params["user"] == "new"
      add_sessions(company_registration: session_params, user: :new, start_date: params["start_date"])
      redirect_to new_user_path
    elsif params["user"] == "exist"
      add_sessions(company_registration: session_params, user: :exist, start_date: params["start_date"])
      redirect_to exist_user_path
    else
      render "company_registrations/new"
    end
  end
  
  def new_user
    @user = User.new
  end
  
  def exist_user
  end
  
  def create
    # 新規ユーザーの場合はユーザーを登録、既存ユーザーの場合はパスワードを確認
    if session[:user] == "new"
      @user = User.new(new_user_params)
      unless @user.valid? 
        render 'company_registrations/new_user' and return
      end
    elsif session[:user] == "exist"
      @user = User.find_by(email: params[:user][:email].downcase)
      unless @user && @user.valid_password?(params[:user][:password])
        flash.now[:denger] = "メールアドレスかパスワードが間違っています。"
        render 'company_registrations/exist_user' and return
      end
    else # 未テスト
      redirect_to new_company_registration_path and return
    end
    
    # 企業情報登録
    @company = Company.find_by(session[:company_registration]["company"]) || Company.new(session[:company_registration]["company"])
    @branch = @company.branches.build(session[:company_registration]["branch"])
    if !!session[:company_registration]["weekly"]
      @weekly = @branch.build_weekly(session[:company_registration]["weekly"])
    elsif !!session[:company_registration]["monthly"]
      @monthly = @branch.build_monthly(session[:company_registration]["monthly"])
      @monthly_periods = session[:company_registration]["monthly_periods"].map { |monthly_period| @monthly.monthly_periods.build(monthly_period) }
    else # 未テスト
      redirect_to new_company_registration_path and return
    end
    
    if @company.valid?
      @company.save
      @user.save
      @user.relationships.create(branch: @branch, master: true, admin: true)
      @branch.create_periods(session[:start_date].in_time_zone)
      delete_sessions(:company_registration, :user, :start_date)
      sign_in(:user, @user)
      redirect_to branch_path(@branch)
    else # 未テスト
      redirect_to new_company_registration_path
    end
  end
  
  private
    def valid_params?
      japanese = {
        "company" => {
          "name" => "企業名"
        },
        "branch" => {
          "name" => "店舗名",
          "start_of_business_hours" => "営業開始時間",
          "end_of_business_hours" => "営業終了時間"
        },
        "one_week" => {
          "start_day" => "シフト開始曜日",
          "deadline_day" => "締め切り日"
        },
        "two_weeks" => {
          "start_day" => "シフト開始曜日",
          "deadline_day" => "締め切り日"
        },
        "harf_month" => {
          "one" => {
            "start_day" => "期間1のシフト開始日",
            "end_day" => "期間1のシフト終了日",
            "deadline_day" => "期間1のシフト締切日"
          },
          "two" => {
            "start_day" => "期間2のシフト開始日",
            "end_day" => "期間2のシフト終了日",
            "deadline_day" => "期間2のシフト締切日"
          }
        },
        "one_month" => {
          "start_day" => "シフト開始日",
          "end_day" => "シフト終了日",
          "deadline_day" => "シフト締切日"
        }
      }
      params["company"].each { |key, value| @error_messages << "#{japanese["company"][key]}を入力してください。" if value.blank? }
      params["branch"].each { |key, value| @error_messages << "#{japanese["branch"][key]}を入力してください。" if value.blank? }
      @error_messages << "営業時間が日をまたぐ場合はチェックを付けてください。" if params["branch"]["start_of_business_hours"].in_time_zone >= params["branch"]["end_of_business_hours"].in_time_zone && params["branch"]["cross_day"] == "0"
      @error_messages << "営業時間が日をまたぐ場合はチェックを付けてください。" if params["branch"]["period_type"].blank?
      
      case params["branch"]["period_type"]
      when "one_week"
        params["one_week"].each { |key, value| @error_messages << "#{japanese["one_week"][key]}を入力してください。" if value.blank? }
        @error_messages << "シフトの開始日が不適切です" unless params["start_date"].in_time_zone.wday == params["one_week"]["start_day"].to_i
      when "two_weeks"
        params["two_weeks"].each { |key, value| @error_messages << "#{japanese["two_weeks"][key]}を入力してください。" if value.blank? }
        @error_messages << "シフトの開始日が不適切です" unless params["start_date"].in_time_zone.wday == params["two_weeks"]["start_day"].to_i
      when "harf_month"
        days = []
        params["harf_month"].each do |num, param|
          param.each do |key, value|
            @error_messages << "#{japanese["harf_month"][num][key]}を入力してください。" if value.blank?
            days << value.to_i if key == "start_day"
          end
        end
         @error_messages << "シフトの開始日が不適切です" unless !!params["start_date"] && days.include?(params["start_date"].in_time_zone.day)
      when "one_month"
        params["one_month"].each { |key, value| @error_messages << "#{japanese["two_weeks"][key]}を入力してください。" if value.blank? }
        @error_messages << "シフトの開始日が不適切です" unless !!params["start_date"] && params["start_date"].in_time_zone.day == params["one_month"]["start_day"].to_i
      end
      
      @error_messages << "マスターユーザーを選択してください" if params["user"].blank?
      @error_messages.blank?
    end
  
    # sessionに入れるもの
    def session_params
      result = {  company: company_params,
                  branch: branch_params }
      if params["branch"]["period_type"] == "one_week"
        result[:weekly] = one_week_params
      elsif params["branch"]["period_type"] == "two_weeks"
        result[:weekly] = two_weeks_params
      elsif params["branch"]["period_type"] == "harf_month"
        result[:monthly] = { period_num: 2 }
        result[:monthly_periods] = [one_harf_month_params, two_harf_month_params]
      elsif params["branch"]["period_type"] == "one_month"
        result[:monthly] = { period_num: 1 }
        result[:monthly_periods] = [one_month_params]
      end
      result
    end
  
    # 企業情報のストロングパラメータ
    def company_params
      params.require(:company).permit(:name)
    end
    
    # 店舗情報のストロングパラメータ
    def branch_params
      result = params.require(:branch).permit(:name, :start_of_business_hours, :end_of_business_hours, :cross_day)
      if params["branch"]["period_type"] == "one_week" || params["branch"]["period_type"] == "two_weeks"
        result[:period_type] = 0
      elsif params["branch"]["period_type"] == "harf_month" || params["branch"]["period_type"] == "one_month"
        result[:period_type] = 1
      end
      result
    end
    
    # 1週間の期間情報のストロングパラメータ
    def one_week_params
      result = params.require(:one_week).permit(:start_day, :deadline_day)
      result[:num_of_weeks] = 1
      result
    end
    
    # 2週間の期間情報のストロングパラメータ
    def two_weeks_params
      result = params.require(:two_weeks).permit(:start_day, :deadline_day)
      result[:num_of_weeks] = 2
      result
    end
    
    # 半月の期間情報のストロングパラメータ（1つ目）
    def one_harf_month_params
      params.require(:harf_month).require(:one).permit(:start_day, :end_day, :deadline_day)
    end
    # 半月の期間情報のストロングパラメータ（2つ目）
    def two_harf_month_params
      params.require(:harf_month).require(:two).permit(:start_day, :end_day, :deadline_day)
    end
    
    # 1ヵ月の期間情報のストロングパラメータ
    def one_month_params
      params.require(:one_month).permit(:start_day, :end_day, :deadline_day)
    end
    
    # before_action
    def have_company_registration_session
      unless !!session[:company_registration]
        redirect_to new_company_registration_path
      end
    end
    
    def new_user_filter
      unless session[:user] == "new"
        redirect_to new_company_registration_path
      end
    end
    
    def exist_user_filter
      unless session[:user] == "exist"
        redirect_to new_company_registration_path
      end
    end
end
