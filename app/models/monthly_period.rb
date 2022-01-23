class MonthlyPeriod < ApplicationRecord
  # モデルの関係性
  belongs_to :monthly
  
  # バリデーション
  validates_associated :monthly
end
