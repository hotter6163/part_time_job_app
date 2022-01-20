class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_branch, only: [:new]
  
  # get new_relationship_path
  # 従業員登録するかの確認
  def new
    @branch = Branch.find_by(id: params[:branch_id])
  end
  
  # post relationships_path
  # 従業員の登録
  def create
    unless branch = Branch.find_by(id: params[:branch_id])
      return
    end
    if params[:master] == "1"
      @relationship = Relationship.create(user: current_user, branch: branch, master: true, admin: true)
    else
      @relationship = Relationship.create(user: current_user, branch: branch)
    end
  end
end
