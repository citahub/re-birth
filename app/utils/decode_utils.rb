class DecodeUtils
  class << self
    # def demo
    #   inputs = [{
    #               "indexed": true,
    #               "name": "from",
    #               "type": "address"
    #             }, {
    #               "indexed": true,
    #               "name": "to",
    #               "type": "address"
    #             }, {
    #               "indexed": false,
    #               "name": "value",
    #               "type": "uint256"
    #             }]
    #   data = "0x000000000000000000000000000000000000000000000000000000000000000a"
    #   topics = [
    #     "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
    #     "0x000000000000000000000000ac30bce77cf849d869aa37e39b983fa50767a2dd",
    #     "0x0000000000000000000000006005ed6b942c99533b896b95fe8a90c7a7ecbf6a"
    #   ]
    #
    #   decode_log(inputs, data, topics)
    # end

    # decode event log event inputs
    #
    # @param o_inputs [[Hash]] event inputs
    # @param data [String] event log data
    # @param topics [[String]] event log topics
    #
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def decode_log(o_inputs, data, topics)
      inputs = o_inputs.map(&:with_indifferent_access)
      decoder = Ethereum::Decoder.new
      unindexed_inputs = inputs.select { |i| !i[:indexed] }
      function_inputs = unindexed_inputs.map { |input| Ethereum::FunctionInput.new(input) }
      decoded_data = decoder.decode_arguments(function_inputs, data)

      unindexed_inputs.each_with_index { |d, i| d[:decoded_data] = decoded_data[i] }

      inputs.select { |i| i[:indexed] }.each_with_index do |a, i|
        a[:decoded_data] = decoder.decode(a[:type], topics[i + 1])
      end

      # add 0x prefix
      inputs = inputs.each do |input|
        decoded_data = input[:decoded_data]
        input[:decoded_data] = "0x" + decoded_data if input[:type] == 'address' && !decoded_data.start_with?("0x")
      end

      (inputs.map.with_index { |input, i| { i => input[:decoded_data] } } + inputs.map { |input| { input[:name] => input[:decoded_data] } }).reduce({}, :merge).with_indifferent_access
    end
  end
end
