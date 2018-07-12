class Api::TransactionSerializer < ActiveModel::Serializer
  attributes :value, :to, :gas_used, :from, :content, :block_number
  attribute :cita_hash, key: :hash
  attributes :timestamp
end
