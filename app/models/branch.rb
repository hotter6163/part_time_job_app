class Branch < ApplicationRecord
  # モデルの関係性
  belongs_to :company
  has_many :relationships, dependent: :destroy
  has_many :periods, dependent: :destroy
  has_one :weekly, dependent: :destroy
  has_one :monthly, dependent: :destroy
  
  # バリデーション
  validates_associated :company
  validates :name,    presence: true,
                      length: { maximum: 137 },
                      uniqueness: { scope: :company_id }
  validates :display_day, inclusion: { in: (0..6).to_a }
  validates :period_type, inclusion: { in: [0, 1] } # 0なら週次、1なら月次設定
  
  # 企業名＋支店名を返す
  def company_name
    "#{company.name} #{name}"
  end
  
  # 既存ユーザーへ従業員登録用メールを送信
  def send_email_to_existing_user(user)
    EmployeeMailer.add_existing_user(self, user).deliver_now
  end
  
  # 新規ユーザーへ従業員登録用メールを送信
  def send_email_to_new_user(email)
    EmployeeMailer.add_new_user(self, email).deliver_now
  end
  
  def subtype
    period_type == 0 ? weekly : monthly
  end
  
  def periods_num_before_deadline
    periods.where('deadline >= ?', Time.zone.now.to_s).count
  end
  
  def maximum_periods_num
    if subtype.class == Weekly
      if subtype.num_of_weeks == 1
        6
      elsif subtype.num_of_weeks == 2
        4
      end
    elsif subtype.class == Monthly
      if subtype.period_num == 1
        2
      elsif subtype.period_num == 2
        4
      end
    end
  end
  
  def create_periods(start_date=(subtype.period.end_day + 1.day))
    (maximum_periods_num - periods_num_before_deadline).times { start_date = subtype.create_period(start_date) }
  end
end
