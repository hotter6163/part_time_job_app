class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include ApplicationHelper
  
  private
    # 新規登録時のストロングパラメータに「last_name, first_name」を追加
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name])
    end
    
    # 送信されたbranch_idが正しいかどうか
    def find_branch
      if params[:branch_id]
        unless Branch.find_by(id: params[:branch_id])
          flash[:denger] = "支店IDが無効です"
          redirect_to root_url 
        end
      end
    end
end
