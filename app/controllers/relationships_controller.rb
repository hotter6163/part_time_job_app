class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :valid_relationship_token
  
  # get new_relationship_path
  # 従業員登録するかの確認
  def new
  end
  
  # post relationships_path
  # 従業員の登録
  def create
    branch = Branch.find_by(id: params[:branch_id])
    @relationship = Relationship.new(user: current_user, branch: branch)
    if @relationship.valid?
      @relationship.save
      flash[:success] = "#{branch.company_name}へ従業員として登録されました"
    else
      if !!branch
        flash[:info] = "#{branch.company_name}には既に従業員として登録されています"
      else
        flash[:denger] = "従業員登録に失敗しました"
      end
    end
    redirect_to root_url
  end
end
