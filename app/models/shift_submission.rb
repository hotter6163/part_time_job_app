class ShiftSubmission < ApplicationRecord
  belongs_to :period
  belongs_to :user
end
