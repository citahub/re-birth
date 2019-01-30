# frozen_string_literal: true

module CitaSync
  class Api
    # New methods without prefix since CITA v0.16
    # now upgrade to CITA v0.20
    METHOD_NAMES = CITA::RPC::METHOD_NAMES

    class << self
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
        cita_url = ENV["CITA_URL"]
        client = CITA::Client.new(cita_url)
        client.rpc.call_rpc(method, jsonrpc: jsonrpc, params: params, id: id)
      end
    end
  end
end
