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

      # post params to cita and get response, decode response body and get hash
      #
      # @param method [String, Symbol] rpc method name
      # @param params [Hash] rpc params
      # @param jsonrpc [String] jsonrpc version, default with "2.0"
      # @param id [Integer] id number
      # @return [Hash, String, Array] json decode to hash
      def call_rpc(method, params: [], jsonrpc: "2.0", id: 83)
        resp = CitaSync::Basic.post(method, params: params, jsonrpc: jsonrpc, id: id)
        Oj.load(resp.body)
      end

    end

  end
end
