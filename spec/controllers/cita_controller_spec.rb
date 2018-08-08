require 'rails_helper'

RSpec.describe CitaController, type: :controller do
  let(:params) do
    {
      jsonrpc: "2.0",
      id: 83,
      method: "getBlockByNumber",
      params: ["0x0", true]
    }
  end

  before do
    mock_get_block_by_number_zero
  end

  it "index response success" do
    post :index, params: params, as: :json
    expect(Oj.load(response.body).dig("result", "header", "number")).to eq "0x0"
  end

end
