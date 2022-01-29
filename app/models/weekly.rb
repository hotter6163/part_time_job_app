class Weekly < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  
  # バリデーション
  validates_associated :branch
  validates :start_day, inclusion: { in: (0..6).to_a }
  
  def period
    Period.find_by(id: period_id)
  end
  
  def create_period(start_date)
    deadline = start_date - deadline_day.day
    end_date = num_of_weeks == 1 ? start_date + 6.day : start_date + 13.day
    period = branch.periods.create(deadline: deadline, start_date: start_date, end_date: end_date)
    
    self.period_id = period.id
    save
    
    end_date + 1.day # 返り値
  end
end
