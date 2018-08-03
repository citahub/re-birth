require 'rails_helper'

RSpec.describe SplitRequestsController, type: :request do
  let(:sync_methods) do
    %w(getBlockByNumber getBlockByHash getMetaData getTransaction)
  end

  let(:persist_methods) do
    %w(getBalance getAbi)
  end

  context "call_sync_methods" do
    let(:block_number) { "0x0" }
    let(:params) do
      {
        method: "getBlockByNumber",
        params: ["0x0", true],
        jsonrpc: "2.0",
        id: 83
      }
    end

    it "find locally if exist" do
      create :block_zero

      expect {
        SplitRequestsController.find(params)
      }.not_to raise_error
    end

    context "find remote if not exist" do
      it "not found in remote" do
        expect {
          SplitRequestsController.find(params)
        }.to raise_error(WebMock::NetConnectNotAllowedError)
      end

      it "find success" do
        mock_get_block_by_number_zero

        expect {
          SplitRequestsController.find(params)
        }.not_to raise_error
      end
    end
  end

  context "call_persist_methods" do
    let(:balance_attr) { attributes_for :balance }
    let(:params) do
      {
        method: "getBalance",
        params: [balance_attr[:address], "0x0"],
        jsonrpc: "2.0",
        id: 83
      }
    end

    it "find locally if exist" do
      create :balance

      expect do
        SplitRequestsController.find(params)
      end.not_to raise_error
    end

    context "find remote if not exist" do
      it "not find in remote" do
        expect do
          SplitRequestsController.find(params)
        end.to raise_error(WebMock::NetConnectNotAllowedError)
      end

      it "find and save" do
        mock_get_balance

        expect {
          SplitRequestsController.find(params)
        }.to change { Balance.count }.by(1)

        balance = Balance.last
        expect(balance.address).to eq balance_attr[:address]
      end
    end
  end



  context "test constants" do
    it "sync methods should be right" do
      expect(SplitRequestsController::SYNC_METHODS).to match_array(sync_methods)
    end

    it "persist methods should be right" do
      expect(SplitRequestsController::PERSIST_METHODS).to match_array(persist_methods)
    end
  end


  context "find choose right method" do
    before do
      allow(SplitRequestsController).to receive(:call_sync_methods) { "call_sync_methods" }
      allow(SplitRequestsController).to receive(:call_persist_methods) { "call_persist_methods" }
      allow(CitaSync::Api).to receive(:call_rpc) { "call_rpc" }
    end

    it "sync methods should call 'call_sync_methods'" do
      sync_methods.each do |method|
        params = {
          jsonrpc: "2.0",
          id: 83,
          method: method,
          params: []
        }
        expect(SplitRequestsController.find(params)).to eq "call_sync_methods"
      end
    end

    it "persist methods should call 'call_persist_methods'" do
      persist_methods.each do |method|
        params = {
          jsonrpc: "2.0",
          id: 83,
          method: method,
          params: []
        }

        expect(SplitRequestsController.find(params)).to eq "call_persist_methods"
      end
    end

    it "any other methods should call 'CitaSync::Api.call_rpc'" do
      params = {
        jsonrpc: "2.0",
        id: 83,
        method: "getLogs",
        params: []
      }

      expect(SplitRequestsController.find(params)).to eq "call_rpc"
    end
  end
end
