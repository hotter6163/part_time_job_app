class Company < ApplicationRecord
  # モデルの関係性
  has_many :branches, dependent: :destroy
  
  # バリデーション
  validates :name,    presence: true,
                      length: { maximum: 137 }
end
