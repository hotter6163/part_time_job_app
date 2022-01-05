class User < ApplicationRecord
  # 保存前に実行するもの
  before_save :downcase_email
  
  # モデルの関係性
  has_many :relationships, dependent: :destroy
  
  # バリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password
  validates :first_name,  presence: true, 
                          length: { maximum: 50 }
  validates :last_name,   presence: true, 
                          length: { maximum: 50 }
  validates :email,       presence: true, 
                          length: { maximum: 255 },
                          format: { with: VALID_EMAIL_REGEX },
                          uniqueness: { case_sensitive: false }
  validates :password,    presence: true, 
                          length: { minimum: 6 }, 
                          allow_nil: true
  
  
  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end
  
  private
    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end
    
    
end
