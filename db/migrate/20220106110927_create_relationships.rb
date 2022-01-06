class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.references :brunch, foreign_key: true, nill: false
      t.references :user, foreign_key: true, nill: false
      t.boolean :admin, default: false
      t.boolean :master, default: false
      
      t.timestamps
    end
    add_index :relationships, [:user_id, :brunch_id], unique: true
  end
end