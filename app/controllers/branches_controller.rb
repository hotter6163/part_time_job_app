class BranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user
  
  def show
  end
  
  def add_employee
  end
  
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
    def admin_user
      @branch = Branch.find_by(id: params[:id])
      unless admin_user?(user: current_user, branch: @branch)
        redirect_to(root_url)
      end
    end
end
