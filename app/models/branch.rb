class Branch < ApplicationRecord
  # モデルの関係性
  belongs_to :company
  has_many :relationships, dependent: :destroy
  
  # バリデーション
  validates :name,    presence: true,
                      length: { maximum: 137 },
                      uniqueness: { scope: :company_id }
end
