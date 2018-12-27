# frozen_string_literal: true

class Api::TransactionSerializer < ActiveModel::Serializer
  attributes :value, :to, :from, :content
  attribute :tx_hash, key: :hash
  attribute :gas_used, key: :gasUsed
  attribute :quota_used, key: :quotaUsed
  attribute :block_number, key: :blockNumber
  attributes :timestamp
  attribute :chain_id, key: :chainId
  attribute :chain_name, key: :chainName
  attribute :error_message, key: :errorMessage

  def chain_id
    object.chain_id || SyncInfo.chain_id
  end

  def value
    decimal_value = @instance_options[:decimal_value]
    return "0x" + object.value.to_s(16).rjust(64, "0") unless decimal_value

    object.value
  end

  def chain_name
    SyncInfo.chain_name
  end

  def block_number
    HexUtils.to_hex(object.block_number)
  end

  def quota_used
    HexUtils.to_hex(object.quota_used)
  end

  alias gas_used quota_used
end
