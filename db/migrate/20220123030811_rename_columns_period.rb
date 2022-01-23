class RenameColumnsPeriod < ActiveRecord::Migration[6.1]
  def change
    rename_column :periods, :start, :start_date
    rename_column :periods, :end, :end_date
  end
end
