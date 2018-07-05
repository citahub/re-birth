module RpcApi
  module V1
    class CitaController < ApplicationController
      # "jsonrpc", "method", "params", "id"
      # check jsonrpc
      # support id, jsonrpc
      # error handle
      def index
        resp = CitaSync::Api.call_rpc(params[:method], params[:params])
        render json: resp
      end
    end
  end
end
