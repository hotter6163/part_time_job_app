class ChangeDataStartTimeAndEndTimeToShiftRequest < ActiveRecord::Migration[6.1]
  def change
    change_column :shift_requests, :start_time, :datetime
    change_column :shift_requests, :end_time, :datetime
  end
end
