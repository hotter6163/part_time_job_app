class RenameTypeCulomnsToPeriodNum < ActiveRecord::Migration[6.1]
  def change
    rename_column :monthlies, :type, :period_num
  end
end
