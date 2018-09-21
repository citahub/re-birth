class Erc20Transfer < ApplicationRecord
  belongs_to :event_log
  belongs_to :tx, class_name: 'Transaction', foreign_key: "transaction_id"
  belongs_to :block, optional: true

  # validates :event_log, uniqueness: true

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
                  }]

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
    def transfer?(topics)
      topics.include?(EVENT_TOPIC)
    end

    # create a erc20_transfer from an event log
    #
    # @param event_log [EventLog]
    # @return [Erc20Transfer]
    def save_from_event_log(event_log)
      return unless transfer?(event_log.topics)

      info = decode(event_log.data, event_log.topics)

      create!({
             address: event_log.address,
             transaction_hash: event_log.transaction_hash,
             block_number: event_log.block_number,
             gas_used: event_log.tx.gas_used,
             from: info[:from],
             to: info[:to],
             value: info[:value],
             event_log: event_log,
             block: event_log.block,
             tx: event_log.tx,
             timestamp: event_log.block&.timestamp
           })
    end


    # parse all event logs in this address if first access this address
    #
    # @param address [String]
    # @return [void]
    def init_address(address)
      event_logs = EventLog.where(address: address)
      ApplicationRecord.transaction do
        event_logs.find_each do |el|
          save_from_event_log(el)
        end
      end
    end
  end

end
