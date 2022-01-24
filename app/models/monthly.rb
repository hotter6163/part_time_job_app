class Monthly < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  has_one :monthly_period, dependent: :destroy
  
  # バリデーション
  validates_associated :branch
end
