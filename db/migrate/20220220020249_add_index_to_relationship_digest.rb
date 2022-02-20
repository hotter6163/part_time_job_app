class AddIndexToRelationshipDigest < ActiveRecord::Migration[6.1]
  def change
    add_index :relationship_digests, [:branch_id, :email]
  end
end
