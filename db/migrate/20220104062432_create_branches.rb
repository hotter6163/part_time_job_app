class CreateBranches < ActiveRecord::Migration[6.1]
  def change
    create_table :branches do |t|
      t.references :company, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
    add_index :branches, [:company_id, :name], unique: true
  end
end
