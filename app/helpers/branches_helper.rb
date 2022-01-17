module BranchesHelper
  def admin_user?(user:, branch:)
    Relationship.find_by(user: user, branch: branch).admin
  end
end
