class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    unless branch = Branch.find_by(id: request.params[:branch_id])
      return
    end
    @relationship = new_relationship(branch)
    @relationship.save if @relationship.valid?
  end
  
  private
    def new_relationship(branch)
      result = branch.relationships.build(user: current_user)
      if request.params[:master] == "1" && !Relationship.exist_master?(branch)
        result.master = true
        result.admin = true
      end
      result
    end
end
