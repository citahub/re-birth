# frozen_string_literal: true

class Api::BlockSerializer < ActiveModel::Serializer
  attributes :version, :header
  attribute :transaction_count, key: :transactionsCount
  attribute :block_hash, key: :hash
end
