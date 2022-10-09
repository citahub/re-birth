class ContractAbi < ApplicationRecord

  STORE_ABI_ADDRESS = "0xffffffffffffffffffffffffffffffffff010001"

  EVENT_CONTRACT_INFO = {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "name": "contractAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "contractName",
        "type": "string"
      },
      {
        "indexed": false,
        "name": "contractVersion",
        "type": "bytes"
      }
    ],
    "name": "V2ContractInfo",
    "type": "event",
    "signature": "0x3c120c6bf98e3676bffc4ca90c12d7562e5c07d34a21a40a1e1beca11a591313"
  }

  def update_abi_info
    return unless is_static
    abi_hex = CitaSync::Api.get_abi(address, "pending")["result"]
    abi = CITA::Utils.to_bytes(abi_hex)
    abi_hash = Oj.load(abi)

    update!(abi: abi_hash)
    self
  end

  class << self

    def save_deploy_info(transaction)
      if transaction.contract_address.present?
        begin
          contract_abi = ContractAbi.find_or_create_by!(address: transaction.contract_address, is_static: true)
        rescue ActiveRecord::RecordNotUnique => e
          retry
        end
      end

      info_logs = transaction.event_logs.to_a.select do |log|
        EVENT_CONTRACT_INFO[:signature] == log.topics.first
      end

      return if info_logs.blank?
      info_logs.sort_by!{ |log| log.transaction_log_index }
      info_logs.each do |info_log|
        contract_info = DecodeUtils.decode_log(EVENT_CONTRACT_INFO[:inputs], info_log.data, info_log.topics)
        contract_abi = ContractAbi.find_or_initialize_by(address: contract_info["contractAddress"])
        contract_abi.contract_name = contract_info["contractName"]
        contract_abi.contract_version = contract_info["contractVersion"]
        contract_abi.block_number = transaction.block_number
        contract_abi.save!
      end
    end

    def save_abi(transaction)
      return unless transaction.to == STORE_ABI_ADDRESS
      contract_address = transaction.data[0...42]
      begin
        contract_abi = ContractAbi.find_or_create_by!(address: contract_address, is_static: true)
      rescue ActiveRecord::RecordNotUnique => e
        retry
      end
      contract_abi.update!(block_number: transaction.block_number)
      contract_abi.update_abi_info
    end

    def save_contract_info(transaction)
      return if transaction.error_message.present?
      ContractAbi.save_deploy_info(transaction)
      ContractAbi.save_abi(transaction)
    end

    def get_static_abi(contract_address)
      contract_abi = ContractAbi.find_by(address: contract_address)

      return nil unless contract_abi
      if !contract_abi.is_static && contract_abi.contract_name.present?
        contract_abi = ContractAbi.order(block_number: :desc).
            where(contract_name: contract_abi.contract_name, is_static: true, contract_version: contract_abi.contract_version).
            where("block_number <= ?", contract_abi.block_number).
            first
      end
      if contract_abi && contract_abi.abi.blank? && contract_abi.contract_name.present?
        contract_abi = contract_abi.update_abi_info
      end
      contract_abi
    end

  end

end
