# frozen_string_literal: true

class Transaction < ApplicationRecord
  self.primary_key = :tx_hash

  # belongs_to :block, optional: true
  belongs_to :block, optional: true, foreign_key: "block_hash", class_name: "Block", primary_key: "block_hash", inverse_of: :transactions
  has_many :event_logs, foreign_key: "transaction_hash", class_name: "EventLog", primary_key: %i(transaction_hash log_index), inverse_of: "tx"
  has_many :erc20_transfers, foreign_key: "transaction_hash", class_name: "Erc20Transfer", primary_key: %i(transaction_hash log_index), inverse_of: "tx"

  # validates :block, presence: true
  validates :tx_hash, presence: true, uniqueness: true

  alias_attribute :gas_used, :quota_used
end
