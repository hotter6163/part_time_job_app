class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :has_token_and_email_params
  before_action :valid_relationship_token
  
  # get new_relationship_path
  # 従業員登録するかの確認
  def new
    @branch = @relationship_digest.branch
  end
  
  # post relationships_path
  # 従業員の登録
  def create
    @branch = @relationship_digest.branch
    @relationship = @branch.relationships.new(user: current_user)
    if @relationship.valid?
      @relationship.save
      flash[:success] = "#{@branch.company_name}の従業員として登録されました。"
    else
      flash[:denger] = "#{@branch.company_name}への従業員登録に失敗したました。"
    end
    redirect_to root_url
  end
  
  private
    def has_token_and_email_params
      unless ["token", "email"].all? { |key| params.keys.include?(key) }
        redirect_to root_url
      end
    end
end
