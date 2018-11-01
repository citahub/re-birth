# frozen_string_literal: true

class Api::TransactionSerializer < ActiveModel::Serializer
  attributes :value, :to, :from, :content
  attribute :cita_hash, key: :hash
  attribute :gas_used, key: :gasUsed
  attribute :block_number, key: :blockNumber
  attributes :timestamp
  attribute :chain_id, key: :chainId
  attribute :chain_name, key: :chainName
  attribute :error_message, key: :errorMessage

  def value
    decimal_value = @instance_options[:decimal_value]
    return HexUtils.to_decimal(object.value) if decimal_value

    object.value
  end

  def chain_name
    SyncInfo.chain_name
  end
end
