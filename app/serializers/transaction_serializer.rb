class TransactionSerializer < ActiveModel::Serializer
  attributes :content, :block_number, :block_hash, :index
  attribute :cita_hash, key: :hash
end
