# decide rpc methods should find in db or call chain.
class SplitRequestsController
  class << self

    # real time sync methods
    SYNC_METHODS = %w(
      getBlockByNumber
      getBlockByHash
      getTransaction
      getMetaData
    )

    # methods that save to db when user called
    PERSIST_METHODS = %w(
      getBalance
      getAbi
    )

    # method of `SYNC_METHODS` should find in db first, if not found, call rpc for result.
    #
    # @param params [Hash] same with rpc params in chains
    # {
    #   "jsonrpc": "2.0",
    #   "id": 83,
    #   "method": "getBlockByNumber",
    #   "params": ["0xF9", true]
    # }
    #
    # @return [Hash] same with chain response.
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

    # method of `PERSIST_METHODS` should find in db first, if not found, call rpc for result and save to db.
    #
    # @param params [Hash] same with rpc params in chain.
    # @return [Hash] same with chain response.
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

    # choose call `call_sync_methods` or `call_persist_methods` by params[:method]
    #
    # @param params [Hash] same with rpc params in chain.
    # @return [Hash] same with chain response.
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
