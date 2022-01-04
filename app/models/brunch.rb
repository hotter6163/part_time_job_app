class Brunch < ApplicationRecord
  # モデルの関係性
  belongs_to :company
  
  # 制約
  validates :name,    presence: { message: '支社名を入力してください。' },
                      length: { maximum: 137, message: '支社名が長すぎます。' },
                      uniqueness: { scope: :company_id, message: 'その支店名は既に登録されています。' }
end
