class Branch < ApplicationRecord
  attr_accessor :relationship_token
  
  # モデルの関係性
  belongs_to :company
  has_many :relationships, dependent: :destroy
  has_many :periods, dependent: :destroy
  has_many :relationship_digests, dependent: :destroy
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
  
  def create_relationship_token(email)
    self.relationship_token = RelationshipDigest.new_token
    relationship_digests.create(digest: RelationshipDigest.digest(@relationship_token), email: email)
  end
  
  # 既存ユーザーへ従業員登録用メールを送信
  def send_email_to_existing_user(user)
    create_relationship_token(user.email)
    EmployeeMailer.add_existing_user(self, @relationship_token, user).deliver_now
  end
  
  # 新規ユーザーへ従業員登録用メールを送信
  def send_email_to_new_user(email)
    create_relationship_token(email)
    EmployeeMailer.add_new_user(self, @relationship_token, email).deliver_now
  end
  
  def subtype
    period_type == 0 ? weekly : monthly
  end
  
  def periods_before_deadline
    periods.where('deadline >= ?', (Time.zone.now - 1.day).to_s)
  end
  
  def periods_before_end_date
    periods.where('end_date >= ?', (Time.zone.now - 1.day).to_s)
  end
  
  def periods_before_start_date
    periods.where('start_date >= ?', (Time.zone.now - 1.day).to_s)
  end
  
  def maximum_periods_num
    case subtype
    when Weekly
      if subtype.num_of_weeks == 1
        6
      elsif subtype.num_of_weeks == 2
        4
      end
    when Monthly
      if subtype.period_num == 1
        2
      elsif subtype.period_num == 2
        4
      end
    end
  end
  
  def create_periods(start_date=(subtype.period.end_date + 1.day))
    (maximum_periods_num - periods_before_deadline.count).times { start_date = subtype.create_period(start_date) }
  end
  
  def belong_to?(user)
    !!relationships.find_by(user: user)
  end
  
  def time_in_business_hours(date, time_with_zone)
    result = "#{date.to_s} #{time_with_zone.to_s(:time)}".in_time_zone
    if start_of_business_hours_on(date) <= result && result <= end_of_business_hours_on(date)
      result
    else
      result + 1.day
    end
  end
  
  def start_of_business_hours_on(date)
    "#{date.to_s} #{start_of_business_hours.to_s(:time)}".in_time_zone
  end
  
  def end_of_business_hours_on(date)
    if cross_day?
      "#{(date + 1.day).to_s} #{end_of_business_hours.to_s(:time)}".in_time_zone
    else
      "#{date.to_s} #{end_of_business_hours.to_s(:time)}".in_time_zone
    end
  end
  
  def employees
    relationships.all.map(&:user)
  end
  
  def shift_requests(period)
    result = Hash.new([])
    employees.each do |employee|
      result[employee.id] = employee.shift_requests(period)
    end
    result
  end
  
  def admin_user?(user)
    relationship = relationships.find_by(user: user)
    relationship && relationship.admin?
  end
  
  def period_including(date)
    periods.find_by("start_date <= ? and end_date >= ?", date, date)
  end
  
  def not_submitted_period_near_deadline(user)
    result = nil
    periods_before_deadline.order(:deadline).each do |period| 
      unless user.shift_submissions.find_by(period: period)
        result = period
        break
      end
    end
    result
  end
  
  def postback_show_submitted_shift_message(user)
    result = "#{company_name}"
    shift_submissions = periods_before_start_date.map { |period| period.shift_submissions.find_by(user: user) }.compact
    if shift_submissions.present?
      shift_submissions.each_with_index do |shift_submission|
        result += "\n#{shift_submission.period.start_to_end}"
        shift_requests = shift_submission.shift_requests.all
        if shift_requests.present?
          shift_requests.each { |shift_request| result += "\n　#{shift_request.date.strftime("%m/%d")}：#{shift_request.start_to_end}" }
        else
          result += "\n　シフト希望がありません。"
        end
      end
    else
      result += "\nシフトは提出されていません"
    end
    result
  end
end
