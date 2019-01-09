# frozen_string_literal: true

class EventLog < ApplicationRecord
  # transaction_log_index is the index of a transaction
  # log_index is the index of a block
  # so transaction_hash & transaction_log_index OR block_hash & log_index can be the primary key
  # in ethereum, the transaction_hash & log_index (no transaction_log_index in a transaction) should be primary key
  self.primary_key = %i(transaction_hash transaction_log_index)

  # belongs_to :block, optional: true
  belongs_to :block, optional: true, foreign_key: "block_hash", class_name: "Block", primary_key: "block_hash", inverse_of: :event_logs
  belongs_to :tx, foreign_key: "transaction_hash", class_name: "Transaction", primary_key: "tx_hash", inverse_of: :event_logs
  has_one :erc20_transfer, foreign_key: %i(transaction_hash transaction_log_index), class_name: "Erc20Transfer", primary_key: %i(transaction_hash transaction_log_index), inverse_of: :event_log

  validates :address, presence: true

  # same transaction_hash & log_index means same event log
  validates :transaction_hash, presence: true
  validates :transaction_log_index, presence: true, uniqueness: { scope: :transaction_hash }
end
