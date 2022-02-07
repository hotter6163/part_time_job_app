class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include ApplicationHelper
  include Devise::Controllers::SignInOut
  
  private
    # 新規登録時のストロングパラメータに「last_name, first_name」を追加
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name])
    end
    
    # before_action
    # 従業員登録時のtokenとemailの確認
    def valid_relationship_token
      @relationship_digest = RelationshipDigest.find_by(email: params[:email])
      unless @relationship_digest.valid_token?(params[:token]) && @relationship_digest.available?
        redirect_to root_url
      end
    end
    
    # ユーザー登録用のパラメータ
    def new_user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
