class ChangeDataDateToShiftRequest < ActiveRecord::Migration[6.1]
  def change
    change_column :shift_requests, :date, :date
  end
end
