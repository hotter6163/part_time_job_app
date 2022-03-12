class LineLink < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true, uniqueness: true
  validates :line_id, presence: true, uniqueness: true
  
  def delete_token
    unless @delete_token
      @delete_token = LineLink.new_token
      update_attribute(:delete_digest,  LineLink.digest(@delete_token))
      update_attribute(:delete_sent_at, Time.zone.now)
    end
    @delete_digest
  end
  
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
