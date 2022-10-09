class DecodeTransaction < ApplicationRecord

  belongs_to :tx, foreign_key: "tx_hash", class_name: "Transaction", primary_key: "tx_hash", inverse_of: :decode_tx

  def api_name
    request_abi && request_abi["name"]
  end

  def contract_address
    address = tx.to
    address = tx.contract_address if tx.is_deploy_contract?
    address
  end

  def pretty_params
    request_abi["inputs"].map{|input|input["name"]}.zip(request_args).to_h
  end

  def auth_mode?
    contract_version.match(/\d{8}/)[0] > "20201218"
  end

  private

  class << self

    def save_decode_transaction(transaction)
      return nil if transaction.error_message.present?
      return nil if transaction.to == ContractAbi::STORE_ABI_ADDRESS
      return nil if transaction.event_logs.size == 0
      return nil if transaction.is_deploy_contract?

      contract_address = transaction.to
      contract_abi = ContractAbi.get_static_abi(contract_address)
      return nil if contract_abi.try(:abi).blank?
      return nil if contract_abi.contract_name.blank?
      web3_abi = Web3::Eth::Contract.new(contract_abi.abi)
      request_abi, request_args = transaction.decode_args(web3_abi)
      request_params = request_abi["inputs"].map{|input|input["name"]}.zip(request_args).to_h
      return nil unless Platform.exists?(system_id: request_params["_systemId"])

      decode_tx = DecodeTransaction.new
      decode_tx.tx_hash = transaction.tx_hash
      decode_tx.request_abi = request_abi
      decode_tx.request_args = request_args
      decode_tx.decode_logs = transaction.decode_logs(web3_abi)
      decode_tx.contract_name = contract_abi.contract_name
      decode_tx.contract_version = contract_abi.contract_version
      decode_tx.timestamp = transaction.timestamp
      decode_tx.tx_index = transaction.index
      decode_tx.block_number = transaction.block_number
      decode_tx.save!

      decode_tx
    end

  end
end
