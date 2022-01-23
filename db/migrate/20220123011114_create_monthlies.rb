class CreateMonthlies < ActiveRecord::Migration[6.1]
  def change
    create_table :monthlies do |t|
      t.references :branch, null: false, foreign_key: true, unique: true
      t.references :period, foreign_key: true
      t.integer :type, default: 1

      t.timestamps
    end
  end
end
