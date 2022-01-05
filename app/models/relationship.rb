class Relationship < ApplicationRecord
  # モデルの関係性
  belongs_to :user
  belongs_to :branch
  
  # バリデーション
  validates :user_id, presence: true
  validates :branch_id, presence: true
end
