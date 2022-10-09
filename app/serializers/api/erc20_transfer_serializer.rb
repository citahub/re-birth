# frozen_string_literal: true

class Api::Erc20TransferSerializer < ActiveModel::Serializer
  attributes :address, :from, :to, :value, :timestamp
  attribute :block_number, key: :blockNumber
  attribute :gas_used, key: :gasUsed
  attribute :quota_used, key: :quotaUsed
  attribute :transaction_hash, key: :hash
  attribute :chain_id, key: :chainId
  attribute :chain_name, key: :chainName

  def chain_id
    object&.tx&.chain_id || SyncInfo.chain_id
  end

  def chain_name
    SyncInfo.chain_name
  end

  def address
    addr = @instance_options[:address]
    return addr unless addr.nil?

    object&.address
  end

  def block_number
    return if object.block_number.nil?

    HexUtils.to_hex(object.block_number)
  end

  def quota_used
    return if object.quota_used.nil?

    HexUtils.to_hex(object.quota_used)
  end

  alias gas_used quota_used
end
