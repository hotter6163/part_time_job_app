class CreateRelationshipDigests < ActiveRecord::Migration[6.1]
  def change
    create_table :relationship_digests do |t|

      t.timestamps
    end
  end
end
