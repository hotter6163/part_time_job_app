class Weekly < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  
  # バリデーション
  validates_associated :branch
end
