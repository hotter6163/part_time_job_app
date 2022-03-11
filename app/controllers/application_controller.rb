class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include ApplicationHelper
  include Devise::Controllers::SignInOut
  include Halt
  
  private
    # 新規登録時のストロングパラメータに「last_name, first_name」を追加
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name])
    end
    
    # before_action
    # 従業員登録時のtokenとemailの確認
    def valid_relationship_token
      if @branch = Branch.find_by(id: params[:branch_id])
        @branch.relationship_digests.where(email: params[:email]).each do |relationship_digest|
          if relationship_digest.available? && relationship_digest.valid_token?(params[:token])
            @relationship_digest = relationship_digest
          end
        end
        unless @relationship_digest
          flash.now[:warning] = "送信されたパラメータが間違っています。"
          redirect_to root_url
        end
      else
        flash.now[:warning] = "送信されたパラメータが間違っています。"
        redirect_to root_url
      end
    end
    
    # ユーザー登録用のパラメータ
    def new_user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
    
    def before_deadline
      unless @period.before_deadline?
        redirect_to root_url
      end
    end
    
    def shift_request_params(shift_request)
      return unless shift_request.values.all?(&:present?)
      result = {}
      result[:date] = shift_request['date']
      result[:start_time] = @branch.time_in_business_hours(shift_request['date'].to_date, shift_request['start_time'].in_time_zone)
      result[:end_time] = @branch.time_in_business_hours(shift_request['date'].to_date, shift_request['end_time'].in_time_zone)
      result[:end_time] + 1.day if result[:start_time] > result[:end_time]
      result
    end
    
    def create_nonce(token)
      ActionController::HttpAuthentication::Digest.nonce(token)
    end
end
