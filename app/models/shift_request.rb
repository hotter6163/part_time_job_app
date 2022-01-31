class ShiftRequest < ApplicationRecord
  # モデルの関係性
  belongs_to :shift_submission
  
  # バリデーション
  validates :date,  presence: true, 
                    uniqueness: { scope: :shift_submission_id }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates_associated :shift_submission
end
