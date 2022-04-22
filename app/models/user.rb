class User < ApplicationRecord
  # 保存前に実行するもの
  before_save :downcase_email
  
  include Line::Client
  
  # モデルの関係性
  has_many :relationships, dependent: :destroy
  has_many :shift_submissions, dependent: :destroy
  has_one :line_link, dependent: :destroy
  
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
  devise  :database_authenticatable, 
          :registerable,
          :recoverable, 
          :rememberable, 
          :timeoutable,
          :validatable
  
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
  
  def admin_branches
    relationships.where(admin: true).map(&:branch)
  end
  
  # 従業員登録しているそれぞれの企業の自分が提出していない一番締め切りが近い期間をまとめて返す
  def not_submitted_periods_near_deadline
    branches.map { |branch| branch.not_submitted_period_near_deadline(self) }.compact
  end
  
  def postback_show_submitted_shift_message
    result = ""
    branches.each_with_index do |branch, index|
      result += "\n\n" unless index == 0
      result += branch.postback_show_submitted_shift_message(self)
    end
    result
  end
  
  def line_link?
    return line_link && line_link.line_id
  end
  
  def send_quickReply_msg(url)
    return unless line_link?
    
    msg = {
      type: 'template',
      altText: '従業員登録用のメッセージを送信しました。',
      template: {
        type: 'buttons',
        text: "従業員登録を行ってください。",
        actions: [
          {
            type: 'uri',
            label: "従業員登録を行ってください。",
            uri: url
          }
        ]
      }
    }
    
    res = client.push_message(line_link.line_id, msg)
    logger.info(res.body)
    logger.info(res.msg)
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
