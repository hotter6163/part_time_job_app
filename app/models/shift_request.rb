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
end
