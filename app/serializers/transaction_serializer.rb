# frozen_string_literal: true

class TransactionSerializer < ActiveModel::Serializer
  attributes :content, :index
  attribute :block_number, key: :blockNumber
  attribute :block_hash, key: :blockHash
  attribute :tx_hash, key: :hash
end
