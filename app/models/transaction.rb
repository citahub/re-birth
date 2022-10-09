# frozen_string_literal: true

class Transaction < ApplicationRecord
  self.primary_key = :tx_hash

  # belongs_to :block, optional: true
  belongs_to :block, optional: true, foreign_key: "block_hash", class_name: "Block", primary_key: "block_hash", inverse_of: :transactions
  has_many :event_logs, foreign_key: "transaction_hash", class_name: "EventLog", inverse_of: "tx"
  has_many :erc20_transfers, foreign_key: "transaction_hash", class_name: "Erc20Transfer", inverse_of: "tx"

  has_one :decode_tx, foreign_key: "tx_hash", class_name: "DecodeTransaction", primary_key: "tx_hash", inverse_of: :tx

  # validates :block, presence: true
  # validates :tx_hash, presence: true, uniqueness: true

  alias_attribute :gas_used, :quota_used

  def is_deploy_contract?
    # to.blank? || to == "0x0000000000000000000000000000000000000000" # 部署合约
    contract_address.present? # 部署合约
  end

  #Web3::Eth::Abi::Utils.signature_hash("modpow(uint256,uint256,uint256)",8)
  def decode_args(web3_abi)
    return [nil, nil] if is_deploy_contract?
    tx_inputs = web3_abi.functions_by_hash[data[2...10]].abi
    inputs = Web3::Eth::Contract::ContractMethod.new(tx_inputs)
    params = Web3::Eth::Abi::AbiCoder.decode_abi(inputs.input_types, [data[10..data.length]].pack('H*'))
    DecodeUtils.to_utf8!(params)

    [tx_inputs, params]
  end

  def decode_logs(web3_abi)
    result = []
    contract_address = self.to
    event_logs.each do |log|
      unless log.address == contract_address
        hash_abi = ContractAbi.get_static_abi(log.address).try(:abi)
        raise "无法获取#{log.address}的abi信息" unless hash_abi
        web3_abi = Web3::Eth::Contract.new(hash_abi)
        contract_address = log.address
      end
      event_abi = web3_abi.events_by_hash[log[:topics].first.gsub("0x", "")].abi
      info = DecodeUtils.decode_log(event_abi["inputs"], log.data, log.topics)
      result[log.transaction_log_index] = {abi: event_abi, info: info, log_address: log.address}
    end
    result
  end

end
