class ShiftSubmission < ApplicationRecord
  # モデルの関係性
  belongs_to :period
  belongs_to :user
  has_many :shift_requests, dependent: :destroy
  
  # バリデーション
  validates :period_id, uniqueness: { scope: :user_id }
end
