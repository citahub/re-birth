module CitaSync
  class Api
    class << self

      METHOD_NAMES = %w(
        net_peerCount
        cita_blockNumber
        cita_sendRawTransaction
        cita_getBlockByHash
        cita_getBlockByNumber
        cita_getTransaction
        eth_getTransactionReceipt
        eth_getLogs
        eth_call
        eth_getTransactionCount
        eth_getCode
        eth_getAbi
        eth_getBalance
        eth_newBlockFilter
        eth_getFilterChanges
        eth_getFilterLogs
      )

      METHOD_NAMES.each do |name|
        define_method name.underscore do |params = []|
          resp = CitaSync::Basic.post(name, params)
          Oj.load(resp.body)
        end
      end

    end

  end
end
