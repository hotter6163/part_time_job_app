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
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
                          
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :timeoutable
  
  def full_name
    "#{last_name} #{first_name}"
  end
  
  def branches
    sql = " select  companies.name as company_name,
                    branches.id as branch_id,
                    branches.name as branch_name,
                    relationships.master,
                    relationships.admin
            from ( select id from users where id = #{id} ) as user
            inner join relationships on user.id = relationships.user_id
            inner join branches on relationships.branch_id = branches.id
            inner join companies on branches.company_id = companies.id"
    ActiveRecord::Base.connection.select_all(sql)
  end
   
  # 特異メソッド
  class << self
    def valid_email?(email)
      VALID_EMAIL_REGEX.match?(email)
    end
  end
  
  # プライベートメソッド  
  private
    def downcase_email
      self.email = email.downcase
    end
  
end
