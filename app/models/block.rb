# frozen_string_literal: true

class Block < ApplicationRecord
  self.primary_key = :block_hash

  has_many :transactions, foreign_key: "block_hash", class_name: "Transaction", primary_key: "block_hash", inverse_of: "block"
  has_many :event_logs, foreign_key: "block_hash", class_name: "EventLog", primary_key: %i(transaction_hash log_index), inverse_of: "block"
  has_many :erc20_transfers, foreign_key: "block_hash", class_name: "Erc20Transfer", primary_key: %i(transaction_hash log_index), inverse_of: "block"

  # store_accessor :header, :number
  # store_accessor :body, :transactions

  validates :block_hash, presence: true, uniqueness: true
  validates :block_number, presence: true, uniqueness: true

  store_accessor :header, :timestamp

  after_create :increase_validator_count

  # get current last block number in database
  #
  # @return [Integer, nil] the current last block number or nil if no block found in db.
  def self.current_block_number
    Block.order(block_number: :desc).first&.block_number
  end

  private

  # increase validator count after block create
  def increase_validator_count
    return if block_number.zero?

    ValidatorCache.increase(header["proposer"])
  end
end
