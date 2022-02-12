class BranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user
  
  # get branch_path(branch)
  def show
    @employees = @branch.employees
    @periods = @branch.periods_before_end_date
  end
  
  # get add_employee_branch_path(branch)
  # 追加する従業員のメールアドレスを入力
  def add_employee
  end
  
  # post send_email_branch_path(branch)
  # メールアドレスに対して従業員登録用のURLを送信
  def send_email
    unless User.valid_email?(params[:email])
      flash[:denger] = "正しいメースアドレスを入力してください。"
      render 'branches/add_employee' and return
    end
    @user = User.find_by(email: params[:email])
    if !!@user
      @branch.send_email_to_existing_user(@user)
      flash.now[:success] = "#{@user.full_name}さんに従業員登録用のメールを送信しました。"
    else
      @branch.send_email_to_new_user(params[:email])
      flash.now[:success] = "新規のユーザー（#{params[:email]}）に従業員登録用のメールを送信しました。"
    end
    render "branches/send_email"
  end
  
  def show_periods
    unless @period = @branch.periods.find_by(id: params[:period_id])
      redirect_to branch_path(@branch) and return
    end
    
    @shift_requests = @branch.shift_requests(@period)
  end
  
  def show_date
    unless @period = @branch.period_including(params[:date])
      redirect_to branch_path(@branch) and return
    end
    @shift_requests = {}
    @branch.employees.each { |employee| @shift_requests[employee.full_name] = employee.shift_request(@period, params[:date]) }
  end
  
  private
    # ログインしているユーザーが管理者権限を持っているか確認
    def admin_user
      @branch = Branch.find_by(id: params[:id])
      unless @branch.admin_user?(current_user)
        redirect_to(root_url)
      end
    end
end
