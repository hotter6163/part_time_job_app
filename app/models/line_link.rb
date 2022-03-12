class LineLink < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true, uniqueness: true
  validates :line_id, presence: true, uniqueness: true
end
