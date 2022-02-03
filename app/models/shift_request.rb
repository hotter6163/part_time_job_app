class ShiftRequest < ApplicationRecord
  # モデルの関係性
  belongs_to :shift_submission
  
  # バリデーション
  validates :date,  presence: true, 
                    uniqueness: { scope: :shift_submission_id }
  validates :start_time,  presence: true
  validates :end_time, presence: true
  validates_associated :shift_submission
  validate :start_time_less_than_end_time
  
  def start_time_less_than_end_time
    unless !!start_time && !!end_time && start_time <= end_time
      errors.add(:start_time, "開始時間より終了時間の方が早いです")
    end
  end
  
  def start_time_of_30_hours_system
    if date == start_time.to_date
      start_time.to_s(:time)
    else
      "#{start_time.hour + 24}:#{start_time.min < 10 ? "0#{start_time.min}" : start_time.min}"
    end
  end
  
  def end_time_of_30_hours_system
    if date == end_time.to_date
      end_time.to_s(:time)
    else
      "#{end_time.hour + 24}:#{end_time.min < 10 ? "0#{end_time.min}" : end_time.min}"
    end
  end
  
  def start_to_end
    "#{start_time_of_30_hours_system} - #{end_time_of_30_hours_system}"
  end
end
