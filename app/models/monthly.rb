class Monthly < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  has_many :monthly_period, dependent: :destroy
  
  # バリデーション
  validates_associated :branch
  validates :period_num, inclusion: { in: (1..2).to_a } # period_numの数で一か月を分割
end
