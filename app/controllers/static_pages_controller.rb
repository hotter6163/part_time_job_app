class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      sql = " select  relationships.master, 
                      relationships.admin, 
                      branches.name as branch_name,
                      branches.id as branch_id
              from  users 
                    inner join relationships on users.id = relationships.user_id 
                    inner join branches on relationships.branch_id = branches.id 
              where user_id = #{current_user.id}"
      @branches = ActiveRecord::Base.connection.select_all(sql)
    end
  end
end
