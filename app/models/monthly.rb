class Monthly < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  belongs_to :period
  has_one :monthly_period
  
  # バリデーション
  validates_associated :branch
end
