# frozen_string_literal: true

class EventLog < ApplicationRecord
  belongs_to :block, optional: true
  belongs_to :tx, class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :event_logs
  has_one :erc20_transfer

  validates :address, presence: true

  # same transaction_hash & log_index means same event log
  validates :transaction_hash, presence: true
  validates :log_index, presence: true, uniqueness: { scope: :transaction_hash }
end
