class Monthly < ApplicationRecord
  # モデルの関係性
  belongs_to :branch
  has_many :monthly_periods, dependent: :destroy
  
  # バリデーション
  validates_associated :branch
  validates :period_num, inclusion: { in: (1..2).to_a } # period_numの数で一か月を分割
  
  def period
    Period.find_by(id: period_id)
  end
  
  def create_period(start_date)
    states = monthly_periods.all.order(:id)
    state = states[0].date(:start, start_date) == start_date ? states[0] : states[-1]
    end_date = state.date(:end, start_date)
    deadline_date = state.date(:deadline, start_date)
    period = branch.periods.create(deadline: deadline_date, start_date: start_date, end_date: end_date)
    
    self.period_id = period.id
    save
    
    end_date + 1.day
  end
end
