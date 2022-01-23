class Monthly < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  belongs_to :period
  
  # バリデーション
  validates_associated :branch
end
