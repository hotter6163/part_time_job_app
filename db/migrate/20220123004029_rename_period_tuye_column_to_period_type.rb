class RenamePeriodTuyeColumnToPeriodType < ActiveRecord::Migration[6.1]
  def change
    rename_column :branches, :period_tuye, :period_type
  end
end
