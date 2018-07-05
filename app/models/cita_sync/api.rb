module CitaSync
  class Api
    class << self

      # New methods without prefix in CITA v0.16
      METHOD_NAMES = %w(
        peerCount
        blockNumber
        sendRawTransaction
        getBlockByHash
        getBlockByNumber
        getTransaction
        getTransactionReceipt
        getLogs
        call
        getTransactionCount
        getCode
        getAbi
        getBalance
        newFilter
        newBlockFilter
        uninstallFilter
        getFilterChanges
        getFilterLogs
        getTransactionProof
        getMetaData
      )

      METHOD_NAMES.each do |name|
        define_method name.underscore do |*params|
          call_rpc(name, params: params)
        end
      end

      def call_rpc(method, params: params, jsonrpc: jsonrpc, id: id)
        resp = CitaSync::Basic.post(method, params: params, jsonrpc: jsonrpc, id: id)
        Oj.load(resp.body)
      end

    end

  end
end
