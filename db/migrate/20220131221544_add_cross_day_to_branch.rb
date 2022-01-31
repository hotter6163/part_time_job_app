class AddCrossDayToBranch < ActiveRecord::Migration[6.1]
  def change
    add_column :branches, :cross_day, :boolean, default: false
  end
end
