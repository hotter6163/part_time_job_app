module BranchesHelper
  # 管理者ユーザーかの確認
  def admin_user?(user:, branch:)
    Relationship.find_by(user: user, branch: branch).admin
  end
end
