class Period < ApplicationRecord
  belongs_to :branch
  
  validates :deadline, uniqueness: { scope: :branch_id }
end
