class Company < ApplicationRecord
  # モデルの関係性
  has_many :brunches, dependent: :destroy
  
  # バリデーション
  validates :name,    presence: { message: '企業名を入力してください。' },
                      length: { maximum: 137, message: '企業名が長すぎます。' }
end
