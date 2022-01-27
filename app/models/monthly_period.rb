class MonthlyPeriod < ApplicationRecord
  # モデルの関係性
  belongs_to :monthly
  
  # バリデーション
  validates_associated :monthly
  validates :start_day, inclusion: { in: (1..30).to_a } 
  validates :end_day, inclusion: { in: (1..30).to_a } 
  validates :deadline_day, inclusion: { in: (1..30).to_a }
end
