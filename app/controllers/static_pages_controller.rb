class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @branches = current_user.branches
    end
  end
end
