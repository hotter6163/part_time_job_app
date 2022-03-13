class LineLink < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true, uniqueness: true
  validates :line_id, presence: true, uniqueness: true
  
  def create_delete_token
    delete_token = LineLink.new_token
    update(delete_digest: LineLink.digest(delete_token), delete_sent_at: Time.zone.now)
    delete_token
  end
  
  def valid_digest?
    Time.zone.now <= delete_sent_at + 30.minutes 
  end
  
  def can_delete?(current_user, token)
    valid_token?(:delete_digest, token) && valid_digest? && valid_user?(current_user)
  end
  
  def valid_user?(current_user)
    user == current_user
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
