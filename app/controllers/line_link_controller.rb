class LineLinkController < ApplicationController
  before_action :has_link_token
  
  def sign_in
  end
  
  def sign_up
    @user = User.new
  end
  
  def create
    if params[:user] == "new"
      @user = User.new(new_user_params)
      unless @user.save
        render 'line_link/sign_up' and return
      end
    elsif params[:user] == "exist"
      @user = User.find_by(email: params[:user][:email].downcase)
      unless @user&.valid_password?(params[:user][:password])
        flash.now[:denger] = "メールアドレスかパスワードが間違っています。"
        render 'line_link/sign_in' and return
      end
    else # 未テスト
      redirect_to root_url and return
    end
    
    sign_in(:user, @user)
    non = nonce(@user.id)
    
    LineLinkNonce.create(nonce: non, user_id: @user.id)
  end
  
  private
    def has_link_token
      unless params[:link_token]
        flash[:danger] = "URLが不適切です。"
        redirect_to root_url
      end
    end
end
