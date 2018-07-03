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
          resp = CitaSync::Basic.post(name, params)
          Oj.load(resp.body)
        end
      end

    end

  end
end
