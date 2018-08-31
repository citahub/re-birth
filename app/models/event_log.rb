class EventLog < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
