require 'rails_helper'

RSpec.describe HexUtils do
  let(:number) { 100 }
  let(:hex_str) { "0x64" }

  context "to_hex" do
    it 'convert decimal number to hex number string' do
      expect(HexUtils.to_hex(100)).to eq hex_str
    end
  end

  context "to_decimal" do
    it "convert hex number string to decimal number" do
      expect(HexUtils.to_decimal(hex_str)).to eq number
    end
  end
end
