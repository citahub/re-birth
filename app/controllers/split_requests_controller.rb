class SplitRequestsController
  class << self

    SYNC_METHODS = %w(
      getBlockByNumber
      getBlockByHash
      getTransaction
      getMetaData
    )

    PERSIST_METHODS = %w(
      getBalance
      getAbi
    )

    def call_sync_methods(params)
      method = params[:method]
      return unless SYNC_METHODS.include?(method)
      method_name = method.underscore
      obj_json = ::LocalInfosController.send(method_name, params[:params])
      return {
        jsonrpc: params[:jsonrpc],
        id: params[:id],
        result: obj_json
      } unless obj_json.nil?

      # call remote
      CitaSync::Api.call_rpc(method, params: params[:params], jsonrpc: params[:jsonrpc], id: params[:id])
    end

    def call_persist_methods(params)
      method = params[:method]
      return unless PERSIST_METHODS.include?(method)
      method_name = method.underscore
      obj_json = ::LocalInfosController.send(method_name, params[:params])
      return {
        jsonrpc: params[:jsonrpc],
        id: params[:id],
        result: obj_json
      } unless obj_json.nil?
      _obj, data = CitaSync::Persist.send(method_name.gsub("get", "save"))
      data
    end

    def find(params)
      method = params[:method]
      if SYNC_METHODS.include?(method)
        call_sync_methods(params)
      elsif PERSIST_METHODS.include?(method)
        call_persist_methods(params)
      else
        CitaSync::Api.call_rpc(method, params: params[:params], jsonrpc: params[:jsonrpc], id: params[:id])
      end
    end
  end

end
