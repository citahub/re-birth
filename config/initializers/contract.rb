module CITA
  class Contract
    # 肯定返回的是数组
    def call_func(method:, params: [], tx: {}) # rubocop:disable Naming/UncommunicativeMethodParamName
      data, output_types = function_data_with_ot(method, *params)
      resp = @rpc.call_rpc(:call, params: [tx.merge(data: data, to: address), "pending"])
      result = resp["result"]

      data = [Utils.remove_hex_prefix(result)].pack("H*")
      return if data.blank?

      re = decode_abi output_types, data

      re.each do |i|
        i.delete!("\x00") if i.instance_of?(String)
        if i.instance_of?(Array)
          i.each do |s|
            s.delete!("\x00") if s.instance_of?(String)
          end
        end
      end

      re
    end
  end
end
