class CreateBrunches < ActiveRecord::Migration[6.1]
  def change
    create_table :brunches do |t|
      t.integer :company_id, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :brunches, [:company_id, :name], unique: true
    add_foreign_key :brunches, :companies
  end
end
