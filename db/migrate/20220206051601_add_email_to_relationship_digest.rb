class AddEmailToRelationshipDigest < ActiveRecord::Migration[6.1]
  def change
    add_column :relationship_digests, :email, :string
    add_index :relationship_digests, :email
  end
end
