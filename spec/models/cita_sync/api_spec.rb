require 'rails_helper'

RSpec.describe CitaSync::Api, type: :model do

  before do
    mock_all
  end

  def is_hex?(str)
    !str.remove("0x")[/\H/]
  end

  context "call_rpc" do
    it "call blockNumber in chain only method name given" do
      resp_body = CitaSync::Api.call_rpc("blockNumber")
      expect(is_hex?(resp_body["result"])).to be true
    end

    # it "given jsonrpc param" do
    #   resp_body = CitaSync::Api.call_rpc("blockNumber", jsonrpc: "3.0")
    #   expect(resp_body).to be nil
    # end

    # let(:id) { 42 }
    # it "given id param" do
    #   resp_body = CitaSync::Api.call_rpc("blockNumber", id: id)
    #   expect(resp_body["id"]).to eq id
    #   expect(is_hex?(resp_body["result"])).to be true
    # end
  end

  context "define method" do
    it "call block_number" do
      resp_body = CitaSync::Api.block_number
      expect(is_hex?(resp_body["result"])).to be true
    end

    let(:block_number) { "0x0" }
    it "call get_block_by_number" do
      resp_body = CitaSync::Api.get_block_by_number(block_number, true)
      expect(resp_body["result"]).not_to be nil
    end

    # it "call get_block_by_number with wrong param length" do
    #   resp_body = CitaSync::Api.get_block_by_number(block_number)
    #   expect(resp_body["result"]).to be nil
    #   expect(resp_body["error"]).not_to be nil
    # end
  end
end
