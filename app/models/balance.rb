class Balance < ApplicationRecord
  validates :address, presence: true
end
