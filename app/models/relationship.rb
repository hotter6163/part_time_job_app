class Relationship < ApplicationRecord
  # モデルの関係性
  belongs_to :user
  belongs_to :brunch
  
  # バリデーション
  validates :user_id, presence: true
  validates :brunch_id, presence: true
end