class ShiftSubmission < ApplicationRecord
  # モデルの関係性
  belongs_to :period
  belongs_to :user
  has_many :shift_requests
end
