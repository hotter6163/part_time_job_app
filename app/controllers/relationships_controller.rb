class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  brfore_action :find_branch, only: [:new]
  
  def new
  end
  
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
