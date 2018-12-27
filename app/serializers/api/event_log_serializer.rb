# frozen_string_literal: true

class Api::EventLogSerializer < ActiveModel::Serializer
  attributes :address, :data, :topics
  attribute :block_hash, key: :blockHash
  attribute :block_number, key: :blockNumber
  attribute :log_index, key: :logIndex
  attribute :transaction_hash, key: :transactionHash
  attribute :transaction_index, key: :transactionIndex
  attribute :transaction_log_index, key: :transactionLogIndex

  def log_index
    HexUtils.to_hex(object.log_index)
  end

  def transaction_index
    HexUtils.to_hex(object.transaction_index)
  end

  def transaction_log_index
    HexUtils.to_hex(object.transaction_log_index)
  end

  def block_number
    HexUtils.to_hex(object.block_number)
  end
end
