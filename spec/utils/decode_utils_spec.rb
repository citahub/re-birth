require 'rails_helper'

RSpec.describe DecodeUtils do
  let(:inputs) do
    [{
       "indexed": true,
       "name": "from",
       "type": "address"
     }, {
       "indexed": true,
       "name": "to",
       "type": "address"
     }, {
       "indexed": false,
       "name": "value",
       "type": "uint256"
     }]
  end

  let(:data) { "0x000000000000000000000000000000000000000000000000000000000000000a" }

  let(:topics) do
    [
      "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
      "0x000000000000000000000000ac30bce77cf849d869aa37e39b983fa50767a2dd",
      "0x0000000000000000000000006005ed6b942c99533b896b95fe8a90c7a7ecbf6a"
    ]
  end

  let(:from) { "0xac30bce77cf849d869aa37e39b983fa50767a2dd" }
  let(:to) { "0x6005ed6b942c99533b896b95fe8a90c7a7ecbf6a" }
  let(:value) { 10 }

  it "decode success" do
    info = DecodeUtils.decode_log(inputs, data, topics)

    %i(from to value).each do |sym|
      expect(info[sym]).to eq send(sym)
    end
  end
end
