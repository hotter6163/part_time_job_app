class Weekly < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  
  # バリデーション
  validates_associated :branch
  validates :start_day, inclusion: { in: (0..6).to_a }
end
