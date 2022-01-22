class AddColoumsToBranch < ActiveRecord::Migration[6.1]
  def change
    add_column :branches, :display_day, :integer, default: 1
    add_column :branches, :start_of_business_hours, :time
    add_column :branches, :end_of_business_hours, :time
    add_column :branches, :period_tuye, :integer, default: 0
  end
end
