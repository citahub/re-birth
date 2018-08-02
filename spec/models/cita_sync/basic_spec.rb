require 'rails_helper'

RSpec.describe CitaSync::Basic, type: :model do
  let(:number) { 100 }
  let(:hex_str) { "0x64" }

  context "number_to_hex_str" do
    it 'convert decimal number to hex number string' do
      expect(CitaSync::Basic.number_to_hex_str(100)).to eq hex_str
    end
  end

  context "hex_str_to_number" do
    it "convert hex number string to decimal number" do
      expect(CitaSync::Basic.hex_str_to_number(hex_str)).to eq number
    end
  end

end
