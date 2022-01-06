class User < ApplicationRecord
  # 保存前に実行するもの
  before_save :downcase_email
  
  # モデルの関係性
  has_many :relationships, dependent: :destroy
  
  # 独自のカラムのバリデーション
  validates :first_name,  presence: true, 
                          length: { maximum: 50 }
  validates :last_name,   presence: true, 
                          length: { maximum: 50 }
                          
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :timeoutable
end
