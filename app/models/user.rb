class User < ApplicationRecord
  # 保存前に実行するもの
  before_save :downcase_email
  
  # モデルの関係性
  has_many :relationships, dependent: :destroy
  
  # 独自のカラムのバリデーション
  validates :first_name,  presence: { message: "「名」を入力してください。" }, 
                          length: { maximum: 50, message: "「名」が長すぎます。" }
  validates :last_name,   presence: { message: "「姓」を入力してください。" }, 
                          length: { maximum: 50, message: "「姓」が長すぎます。" }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
