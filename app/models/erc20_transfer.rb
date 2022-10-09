# frozen_string_literal: true

class Erc20Transfer < ApplicationRecord
  self.primary_key = %i(transaction_hash transaction_log_index)

  belongs_to :block, optional: true, foreign_key: "block_hash", class_name: "Block", primary_key: "block_hash", inverse_of: "erc20_transfers"
  belongs_to :tx, class_name: "Transaction", foreign_key: "transaction_hash", primary_key: "tx_hash", inverse_of: :erc20_transfers
  belongs_to :event_log, class_name: "EventLog", foreign_key: %i(transaction_hash transaction_log_index), primary_key: %i(transaction_hash transaction_log_index), inverse_of: :erc20_transfer

  before_save :downcase_before_save

  alias_attribute :gas_used, :quota_used

  # validates :event_log, uniqueness: true

  # Web3::Eth::Abi::Utils.signature_hash
  # first of topics: event signature
  # web3.eth.abi.encodeEventSignature('Transfer(address,address,uint256)')
  EVENT_TOPIC = "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"

  # event log abi event inputs
  EVENT_INPUTS = [{
    "indexed": true,
    "name": "from",
    "type": "address"
  }, {
    "indexed": true,
    "name": "to",
    "type": "address"
  }, {
    "indexed": false,
    "name": "value",
    "type": "uint256"
  }].freeze

  private

  def downcase_before_save
    self.address = address&.downcase
  end

  class << self
    # decode data and topics to get from to and value
    #
    # @param data [String]
    # @param topics [[String]]
    # @return [Hash] key of 0, 1, 2, from, to, value
    def decode(data, topics)
      DecodeUtils.decode_log(EVENT_INPUTS, data, topics)
    end

    # check a event log is a transfer by topics
    #
    # @param topics [[String]]
    # @return [true, false]
    def transfer?(event_log)
      return false unless event_log.topics.include?(EVENT_TOPIC)
      contract_abi = ContractAbi.find_by(address: event_log.address)
      return false if contract_abi.try(:contract_name).blank?
      true
    end

    # create a erc20_transfer from an event log
    #
    # @param event_log [EventLog]
    # @return [Erc20Transfer]
    def save_from_event_log(event_log)
      return unless transfer?(event_log)

      info = decode(event_log.data, event_log.topics)
      return if info[:value].blank?

      create!(
        address: event_log.address,
        transaction_hash: event_log.transaction_hash,
        log_index: event_log.log_index,
        transaction_log_index: event_log.transaction_log_index,
        block_number: event_log.block_number,
        block_hash: event_log.block_hash,
        quota_used: event_log.tx.quota_used,
        from: info[:from],
        to: info[:to],
        value: info[:value],
        contract_name: ContractAbi.find(event_log.address).contract_name,
        timestamp: event_log.tx&.timestamp
      )
    end

    # parse all event logs in this address if first access this address
    #
    # @param address [String]
    # @return [void]
    def init_address(address)
      event_logs = EventLog.where("address ILIKE ?", address)
      ApplicationRecord.transaction do
        event_logs.find_each do |el|
          save_from_event_log(el)
        end
      end
    end
  end
end
