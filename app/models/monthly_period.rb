class MonthlyPeriod < ApplicationRecord
  # モデルの関係性
  belongs_to :monthly
  
  # バリデーション
  validates_associated :monthly
  validates :start_day, inclusion: { in: (1..30).to_a } # period_numの数で一か月を分割
  validates :end_day, inclusion: { in: (1..30).to_a } # period_numの数で一か月を分割
  validates :deadline_day, inclusion: { in: (1..30).to_a } # period_numの数で一か月を分割
end
