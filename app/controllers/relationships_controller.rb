class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    if request[:master] == "1"
      save_relationship request[:branch_id], master: true
    else
      save_relationship request[:branch_id]
    end
  end
end
