# frozen_string_literal: true

class Api::BlockSerializer < ActiveModel::Serializer
  attributes :version, :header
  attribute :transaction_count, key: :transactionsCount
  attribute :cita_hash, key: :hash
end
