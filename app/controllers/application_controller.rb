class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include ApplicationHelper
  include Devise::Controllers::SignInOut
  
  private
    # 新規登録時のストロングパラメータに「last_name, first_name」を追加
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name])
    end
    
    # 送信されたbranch_idが正しいかどうか
    def valid_relationship_token
      digest = RelationshipDigest.digest(params[:token])
      unless @relationship_digest = RelationshipDigest.find_by(digest: digest)
        redirect_to root_url
      end
    end
    
    def redirect_new_relationships
      redirect_to new_relationship_path(token: params[:token])
    end
    
    def new_user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
