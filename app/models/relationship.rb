class Relationship < ApplicationRecord
  # モデルの関係性
  belongs_to :user
  belongs_to :branch
  
  # バリデーション
  validates :user_id, presence: true
  validates :branch_id, presence: true,
                        uniqueness: { scope: :user_id }
  
  # 特異メソッド
  class << self
    def exist_master?(branch)
      !!self.find_by(branch_id: branch.id, master: 1)
    end
  end
end