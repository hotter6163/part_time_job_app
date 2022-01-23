class CreateShiftSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :shift_submissions do |t|
      t.references :period, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :shift_submissions, [:period_id, :user_id], unique: true
  end
end
