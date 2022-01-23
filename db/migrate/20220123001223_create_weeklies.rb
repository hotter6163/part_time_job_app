class CreateWeeklies < ActiveRecord::Migration[6.1]
  def change
    create_table :weeklies do |t|
      t.references :branch, foreign_key: true, uniqueness: true
      t.integer :start_day
      t.integer :deadline_day
      t.references :period, foreign_key: true
      t.integer :num_of_weeks

      t.timestamps
    end
  end
end
