class CreateBrunches < ActiveRecord::Migration[6.1]
  def change
    create_table :brunches do |t|
      t.references :company, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
    add_index :brunches, [:company_id, :name], unique: true
  end
end
