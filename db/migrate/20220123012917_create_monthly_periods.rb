class CreateMonthlyPeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :monthly_periods do |t|
      t.references :monthly, null: false, foreign_key: true
      t.integer :start_day
      t.integer :end_day
      t.integer :deadline_day

      t.timestamps
    end
  end
end
