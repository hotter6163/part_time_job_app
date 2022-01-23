class Period < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  has_many :shift_submissions, dependent: :destroy
  
  # バリデーション
  validates :deadline, uniqueness: { scope: :branch_id }
end
