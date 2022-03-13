class Period < ApplicationRecord
  include Comparable
  include Rails.application.routes.url_helpers
  
  # モデルの関係性
  belongs_to :branch
  has_many :shift_submissions, dependent: :destroy
  
  # バリデーション
  validates :deadline, uniqueness: { scope: :branch_id }
  validates :start_date, uniqueness: { scope: :branch_id }
  
  def start_to_end
    "#{start_date.strftime("%m/%d")} - #{end_date.strftime("%m/%d")}"
  end
  
  def days
    (0..(end_date - start_date).to_i).map { |n| start_date + n.day }
  end
  
  def before_deadline?
    Time.zone.now < (deadline + 1.day).in_time_zone
  end
  
  def is_date_in?(date)
    start_date <= date && date < end_date + 1.day
  end
  
  def <=>(period)
    if deadline > period.deadline
      1
    elsif deadline == period.deadline
      if start_date > period.start_date
        1
      elsif start_date == period.start_date
        if end_date > period.end_date
          1
        elsif end_date == period.end_date
          0
        else
          -1
        end
      else
        -1
      end
    else
      -1
    end
  end
  
  def line_button_message(url)
    {
      type: 'template',
      altText: "#{branch.company_name}へシフトを提出してください。",
      template: {
        type: 'buttons',
        text: "#{branch.company_name}\n期間：#{start_to_end}\n締切：#{deadline.strftime("%m/%d")}",
        defaultAction: {
          type: 'uri',
          label: "シフトを提出",
          uri: url
        },
        actions: [
          {
            type: 'uri',
            label: "シフトを提出",
            uri: url
          }
        ]
      }
    }
  end
end
