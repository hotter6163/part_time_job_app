class User < ApplicationRecord
  # 保存前に実行するもの
  before_save :downcase_email
  
  # モデルの関係性
  has_many :relationships, dependent: :destroy
  has_many :shift_submissions, dependent: :destroy
  
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
  
  # ユーザーのフルネームを返す
  def full_name
    "#{last_name} #{first_name}"
  end
  
  # ユーザーが所属している企業一覧を返す
  def branches
    relationships.all.map(&:branch)
  end
  
  def shift_requests(period)
    result = Hash.new([])
    if shift_submission = shift_submissions.find_by(period: period)
      shift_submission.shift_requests.all.each { |shift_request| result[shift_request.date.to_s] = shift_request.start_to_end }
    end
    result
  end
  
  def shift_request(period, date)
    return nil unless shift_submission = shift_submissions.find_by(period: period)
    shift_submission.shift_requests.find_by(date: date)
  end
  
  def submit_shift?(period)
    !!shift_submissions.find_by(period: period)
  end
  
  # 特異メソッド
  class << self
    # メールアドレスの形式が正しいかの判定
    def valid_email?(email)
      VALID_EMAIL_REGEX.match?(email)
    end
  end
  
  # プライベートメソッド  
  private
    # メールアドレスの小文字化
    def downcase_email
      self.email = email.downcase
    end
  
end
