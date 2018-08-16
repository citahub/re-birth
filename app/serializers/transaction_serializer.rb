class TransactionSerializer < ActiveModel::Serializer
  attributes :content, :index
  attribute :block_number, key: :blockNumber
  attribute :block_hash, key: :blockHash
  attribute :cita_hash, key: :hash
end
