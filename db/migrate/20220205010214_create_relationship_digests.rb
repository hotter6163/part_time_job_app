class CreateRelationshipDigests < ActiveRecord::Migration[6.1]
  def change
    create_table :relationship_digests do |t|
      t.references :branch, foreign_key: true
      t.string :digest
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
