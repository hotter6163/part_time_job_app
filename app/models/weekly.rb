class Weekly < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  
  # バリデーション
  validates_associated :branch
  validates :start_day, inclusion: { in: (0..6).to_a }
  
  def period
    Period.find_by(id: period_id)
  end
  
  def make_periods
    today = Time.zone.now.to_s
    count = branch.periods.where('deadline >= ?', today).count
    # while count < 4 do
      
  end
end
