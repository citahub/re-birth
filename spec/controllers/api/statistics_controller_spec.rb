require 'rails_helper'

RSpec.describe Api::StatisticsController, type: :controller do


  let(:body) { Oj.load(response.body).with_indifferent_access }
  let(:result) { body[:result] }

  let(:block_zero_attr) { attributes_for(:block_zero) }
  let(:block_zero_header) { block_zero_attr[:header] }
  let(:block_zero_proposer) { block_zero_header[:proposer] }

  let(:block_one_attr) { attributes_for(:block_one) }
  let(:block_one_header) { block_one_attr[:header] }
  let(:block_one_proposer) { block_one_header[:proposer] }

  before do
    20.times.each do |i|
      # 1 second
      create :block_zero, header: block_zero_header.merge(timestamp: block_zero_header[:timestamp] + i * 1000), cita_hash: "0x#{SecureRandom.hex(32)}", block_number: i
    end
    10.times.each do |i|
      create :block_one, header: block_one_header.merge(timestamp: block_zero_header[:timestamp] + (20 + i) * 1000), cita_hash: "0x#{SecureRandom.hex(32)}", block_number: (20 + i)
    end

    create :meta_data, validators: [block_zero_proposer, block_one_proposer], block: Block.last
  end


  context "proposals" do
    it "success" do
      post :index, params: { type: 'proposals' }

      expected_result = [
        {
          validator: block_zero_proposer,
          count: 20,
        },
        {
          validator: block_one_proposer,
          count: 10
        }
      ]

      expect(result).to match_array(expected_result)
    end
  end

  context "brief" do
    it "success" do
      post :index, params: { type: "brief" }

      expected_result = {
        tps: 10 / 29.to_f,
        tpb: 10 / 30.to_f,
        ipb: 29 / 30.to_f
      }

      result.each do |key, _value|
        expect(result[key]).to be_within(0.0001).of(expected_result[key.to_sym])
      end
    end
  end

  context "any other" do
    it "no content" do
      post :index, params: { type: "any" }

      expect(response).to have_http_status(:no_content)
    end
  end

end
