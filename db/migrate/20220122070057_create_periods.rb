class CreatePeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :periods do |t|
      t.references :branch, foreign_key: true
      t.date :deadline
      t.date :start
      t.date :end

      t.timestamps
    end
    add_index :periods, [:branch_id, :deadline], unique: true
    add_index :periods, [:branch_id, :start], unique: true
  end
end
