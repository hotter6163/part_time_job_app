class CreateShiftRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :shift_requests do |t|
      t.references :shift_submission, null: false, foreign_key: true
      t.integer :date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
    add_index :shift_requests, [:shift_submission_id, :date], unique: true
  end
end
