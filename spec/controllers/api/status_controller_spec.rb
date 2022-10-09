require 'rails_helper'

RSpec.describe Api::StatusController, type: :controller do
  let(:result) { Oj.load(response.body).with_indifferent_access[:result] }

  before do
    create :block_zero
    mock_block_number
  end

  context "index" do
    it "with no running" do
      post :index

      expect(result["status"]).to eq "not running"
      expect(result["currentBlockNumber"]).to eq "0x0"
      expect(result["currentChainBlockNumber"]).to eq "0x1"
    end
  end
end
