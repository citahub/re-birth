module CitaSync
  module Basic
    class << self

      def number_to_hex_str(number)
        "0x" + number.to_s(16)
      end

      def hex_str_to_number(str)
        str.to_i(16)
      end

      def post(method, params = [])
        conn.post("/", params(method, params))
      end

      def params(method, params = [])
        {
          jsonrpc: "2.0",
          id: 83,
          method: method,
          params: params
        }.to_json
      end

      def conn
        Faraday.new(url: cita_url) do |faraday|
          faraday.headers['Content-Type'] = 'application/json'
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to $stdout
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
      end

      def cita_url
        ENV.fetch("CITA_URL")
      end

      # make params key chainId => chain_id
      # not deep transfer keys, only transfer first level keys
      def transfer_params(params)
        params.map { |k, v| { k.to_s.underscore => v } }.reduce(:merge)
      end

      # select params
      def select_params(params, keys = [])
        underscore_params = transfer_params(params)
        underscore_params.select { |k, _v| keys.include?(k) }
      end
    end

  end
end
