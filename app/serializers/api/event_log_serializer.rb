# frozen_string_literal: true

class Api::EventLogSerializer < ActiveModel::Serializer
  attributes :address, :data, :topics
  attribute :block_hash, key: :blockHash
  attribute :block_number, key: :blockNumber
  attribute :log_index, key: :logIndex
  attribute :transaction_hash, key: :transactionHash
  attribute :transaction_index, key: :transactionIndex
  attribute :transaction_log_index, key: :transactionLogIndex
end
