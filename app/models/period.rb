class Period < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  has_many :shift_submissions, dependent: :destroy
  
  # バリデーション
  validates :deadline, uniqueness: { scope: :branch_id }
  validates :start_date, uniqueness: { scope: :branch_id }
  
  def start_to_end
    "#{start_date} - #{end_date}"
  end
  
  def days
    (0..(end_date - start_date).to_i).map { |n| start_date + n.day }
  end
end
