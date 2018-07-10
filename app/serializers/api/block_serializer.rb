class Api::BlockSerializer < ActiveModel::Serializer
  attributes :version, :header
  attribute :transaction_count, key: :transactions_count
  attribute :cita_hash, key: :hash
end
