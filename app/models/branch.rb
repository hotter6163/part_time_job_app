class Branch < ApplicationRecord
  # モデルの関係性
  belongs_to :company
  has_many :relationships, dependent: :destroy
  
  # バリデーション
  validates :name,    presence: true,
                      length: { maximum: 137 },
                      uniqueness: { scope: :company_id }
                      
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
end
