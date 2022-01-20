module RelationshipsHelper
  # 従業員登録
  def create_relationship(branch_id)
    if branch = Branch.find_by(id: branch_id)
      @relationship = branch.relationships.create(user: current_user)
    end
  end
end
