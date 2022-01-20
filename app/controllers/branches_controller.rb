class BranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user
  
  # get branch_path(branch)
  def show
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
      flash[:success] = "#{@user.full_name}さんに従業員登録用のメールを送信しました。"
    else
      @branch.send_email_to_new_user(params[:email])
      flash[:success] = "新規のユーザー（#{params[:email]}）に従業員登録用のメールを送信しました。"
    end
    render "branches/send_email"
  end
  
  private
    # ログインしているユーザーが管理者権限を持っているか確認
    def admin_user
      @branch = Branch.find_by(id: params[:id])
      unless admin_user?(user: current_user, branch: @branch)
        redirect_to(root_url)
      end
    end
end
