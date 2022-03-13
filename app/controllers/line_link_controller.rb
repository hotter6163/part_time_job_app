class LineLinkController < ApplicationController
  include Line::Client
  
  before_action :has_link_token, only: [:log_in, :sign_in, :create]
  before_action :authenticate_user!, only: [:check_delete, :delete]
  before_action :can_delete, onlu: [:check_delete, :delete]
  
  def log_in
  end
  
  def sign_up
    @user = User.new
  end
  
  def create
    if params[:status] == "new"
      @user = User.new(new_user_params)
      unless @user.save
        render 'line_link/sign_up' and return
      end
    elsif params[:status] == "exist"
      return unless login(params[:user], render_template: 'line_link/sign_in', log_in: false)
    else # 未テスト
      redirect_to root_url and return
    end
    
    sign_in(:user, @user)
    nonce = create_nonce(current_user.id)
    @line_api_link = "https://access.line.me/dialog/bot/accountLink?linkToken=#{params[:link_token]}&nonce=#{nonce}"
    
    LineLinkNonce.create(nonce: nonce, user_id: current_user.id)
  end
  
  def check_delete
  end
  
  def delete
    client.unlink_user_rich_menu(@line_link.line_id)
    @line_link.destroy
  end
  
  private
    def has_link_token
      unless params[:link_token]
        flash[:danger] = "URLが不適切です。"
        redirect_to root_url
      end
    end
    
    def can_delete
      @line_link = LineLink.find_by(id: params[:id])
      unless @line_link&.can_delete?(current_user, params[:delete_token])
        flash[:danger] = "送信されたパラメータが間違っています。"
        redirect_to root_url
      end
    end
end
