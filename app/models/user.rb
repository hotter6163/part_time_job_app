class User < ApplicationRecord
  # 保存前に実行するもの
  before_save :downcase_email
  
  # モデルの関係性
  has_many :relationships, dependent: :destroy
  
  # バリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password
  validates :first_name,  presence: { message: "「名」を入力してください。" }, 
                          length: { maximum: 50, message: "「名」が長すぎます。" }
  validates :last_name,   presence: { message: "「姓」を入力してください。" }, 
                          length: { maximum: 50, message: "「姓」が長すぎます。" }
  validates :email,       presence: { message: "メールアドレスを入力してください。" }, 
                          length: { maximum: 255, message: "メールアドレスが長すぎます" },
                          format: { with: VALID_EMAIL_REGEX, message: "メールアドレスの形式が正しくありません。" },
                          uniqueness: { case_sensitive: false, message: "そのメールアドレスは既に登録されています。" }
  validates :password,    presence: { message: "パスワードを入力してください。" }, 
                          length: { minimum: 6, message: "パスワードは6文字以上入力してください。" }, 
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
