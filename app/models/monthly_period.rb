class MonthlyPeriod < ApplicationRecord
  # モデルの関係性
  belongs_to :monthly
  
  # バリデーション
  validates_associated :monthly
  validates :start_day, inclusion: { in: (1..30).to_a } 
  validates :end_day, inclusion: { in: (1..30).to_a } 
  validates :deadline_day, inclusion: { in: (1..30).to_a }
  
  def date(attribute, start_date)
    day = send("#{attribute}_day")
    if day == 30
      result = Date.new(start_date.year, start_date.month + 1, 1).in_time_zone - 1.day
    else
      result = Date.new(start_date.year, start_date.month, day).in_time_zone
    end
    
    case attribute
    when :start then
      result
    when :end then
      if result >= start_date
        result
      else
        result + 1.month
      end
    when :deadline then
      if result <= start_date
        result
      else
        result - 1.month
      end
    end
  end
end
