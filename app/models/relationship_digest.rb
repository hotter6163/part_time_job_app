class RelationshipDigest < ApplicationRecord
  belongs_to :branch
  
  def available?
    !used? && Time.zone.now <= created_at + 3.day
  end
  
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

  # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
