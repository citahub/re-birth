class Api::Erc20TransferSerializer < ActiveModel::Serializer
  attributes :address, :from, :to, :value
  attribute :block_number, key: :blockNumber
  attribute :gas_used, key: :gasUsed
  attribute :transaction_hash, key: :hash
end
