class Api::TransactionSerializer < ActiveModel::Serializer
  attributes :value, :to, :from, :content
  attribute :cita_hash, key: :hash
  attribute :gas_used, key: :gasUsed
  attribute :block_number, key: :blockNumber
  attributes :timestamp
end
