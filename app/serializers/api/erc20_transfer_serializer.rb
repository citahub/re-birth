class Api::Erc20TransferSerializer < ActiveModel::Serializer
  attributes :address, :from, :to, :value
  attribute :block_number, key: :blockNumber
  attribute :gas_used, key: :gasUsed
  attribute :transaction_hash, key: :hash
  attribute :chain_id, key: :chainId
  attribute :chain_name, key: :chainName

  def chain_id
    SyncInfo.chain_id
  end

  def chain_name
    SyncInfo.chain_name
  end
end
