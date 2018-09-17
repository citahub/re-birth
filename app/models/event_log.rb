class EventLog < ApplicationRecord
  validates :address, presence: true

  # same transaction_hash & log_index means same event log
  validates :transaction_hash, presence: true
  validates :log_index, presence: true, uniqueness: { scope: :transaction_hash }
end
